# React Server Components

## Core Concepts

### Server vs Client Components

```
Server Components:
- Default in Next.js App Router
- Run only on server
- Can access backend directly
- No JavaScript sent to client
- Cannot use hooks, events, browser APIs

Client Components:
- Marked with "use client"
- Run on client (and server for SSR)
- Can use hooks and interactivity
- JavaScript sent to client
```

### When to Use Each

| Feature | Server Component | Client Component |
|---------|------------------|------------------|
| Fetch data | ✅ Direct DB access | ❌ Via API |
| Access secrets | ✅ Direct | ❌ Never |
| Use hooks | ❌ | ✅ |
| Event handlers | ❌ | ✅ |
| Browser APIs | ❌ | ✅ |
| State | ❌ | ✅ |
| Effects | ❌ | ✅ |

---

## Server Component Patterns

### Data Fetching

```tsx
// app/users/page.tsx
// This is a Server Component by default

import { db } from "@/lib/db";

async function UsersPage() {
  // Direct database access - no API needed
  const users = await db.user.findMany({
    select: { id: true, name: true, email: true },
  });

  return (
    <ul>
      {users.map((user) => (
        <li key={user.id}>{user.name}</li>
      ))}
    </ul>
  );
}

export default UsersPage;
```

### Parallel Data Fetching

```tsx
// Fetch in parallel for better performance
async function Dashboard() {
  // These run in parallel
  const [user, posts, notifications] = await Promise.all([
    getUser(),
    getPosts(),
    getNotifications(),
  ]);

  return (
    <div>
      <UserHeader user={user} />
      <PostList posts={posts} />
      <NotificationBell count={notifications.length} />
    </div>
  );
}
```

### Streaming with Suspense

```tsx
import { Suspense } from "react";

async function SlowData() {
  const data = await fetchSlowData(); // Takes 3 seconds
  return <div>{data}</div>;
}

async function FastData() {
  const data = await fetchFastData(); // Takes 100ms
  return <div>{data}</div>;
}

export default function Page() {
  return (
    <div>
      {/* Fast content renders immediately */}
      <Suspense fallback={<Skeleton />}>
        <FastData />
      </Suspense>

      {/* Slow content streams in when ready */}
      <Suspense fallback={<Skeleton />}>
        <SlowData />
      </Suspense>
    </div>
  );
}
```

### Nested Suspense Boundaries

```tsx
export default function ProductPage({ id }: { id: string }) {
  return (
    <Suspense fallback={<ProductSkeleton />}>
      <ProductDetails id={id} />

      <Suspense fallback={<ReviewsSkeleton />}>
        <ProductReviews id={id} />
      </Suspense>

      <Suspense fallback={<RecommendationsSkeleton />}>
        <Recommendations id={id} />
      </Suspense>
    </Suspense>
  );
}
```

---

## Client Component Patterns

### Marking as Client Component

```tsx
"use client";

import { useState } from "react";

export function Counter() {
  const [count, setCount] = useState(0);

  return (
    <button onClick={() => setCount((c) => c + 1)}>
      Count: {count}
    </button>
  );
}
```

### Composition: Server → Client

```tsx
// Server Component
import { Counter } from "./Counter"; // Client Component

export default async function Page() {
  const initialCount = await getInitialCount();

  return (
    <div>
      <h1>Dashboard</h1>
      {/* Pass server data to client component */}
      <Counter initialCount={initialCount} />
    </div>
  );
}
```

### Slots Pattern (Children)

```tsx
// ClientWrapper.tsx
"use client";

import { useState } from "react";

export function Accordion({ children }: { children: React.ReactNode }) {
  const [isOpen, setIsOpen] = useState(false);

  return (
    <div>
      <button onClick={() => setIsOpen(!isOpen)}>Toggle</button>
      {isOpen && children}
    </div>
  );
}

// page.tsx (Server Component)
import { Accordion } from "./Accordion";

export default async function Page() {
  const content = await getContent();

  return (
    <Accordion>
      {/* Server Component rendered on server, passed as children */}
      <ExpensiveServerComponent data={content} />
    </Accordion>
  );
}
```

---

## Data Patterns

### Server Actions

```tsx
// actions.ts
"use server";

import { db } from "@/lib/db";
import { revalidatePath } from "next/cache";

export async function createPost(formData: FormData) {
  const title = formData.get("title") as string;
  const content = formData.get("content") as string;

  await db.post.create({
    data: { title, content },
  });

  revalidatePath("/posts");
}
```

```tsx
// form.tsx
"use client";

import { createPost } from "./actions";

export function CreatePostForm() {
  return (
    <form action={createPost}>
      <input name="title" placeholder="Title" />
      <textarea name="content" placeholder="Content" />
      <button type="submit">Create</button>
    </form>
  );
}
```

### Optimistic Updates

```tsx
"use client";

import { useOptimistic } from "react";
import { toggleLike } from "./actions";

export function LikeButton({
  postId,
  initialLiked,
}: {
  postId: string;
  initialLiked: boolean;
}) {
  const [optimisticLiked, setOptimisticLiked] = useOptimistic(
    initialLiked,
    (state, _) => !state
  );

  async function handleLike() {
    setOptimisticLiked(!optimisticLiked);
    await toggleLike(postId);
  }

  return (
    <button onClick={handleLike}>
      {optimisticLiked ? "❤️" : "🤍"}
    </button>
  );
}
```

### Pending States

```tsx
"use client";

import { useFormStatus } from "react-dom";

function SubmitButton() {
  const { pending } = useFormStatus();

  return (
    <button type="submit" disabled={pending}>
      {pending ? "Submitting..." : "Submit"}
    </button>
  );
}

export function Form() {
  return (
    <form action={submitAction}>
      <input name="email" type="email" />
      <SubmitButton />
    </form>
  );
}
```

---

## Caching Patterns

### Request Memoization

```tsx
// This function is called twice but only fetches once
async function getUser(id: string) {
  const res = await fetch(`https://api.example.com/users/${id}`);
  return res.json();
}

export default async function Page({ params }: { params: { id: string } }) {
  // Both components call getUser, but fetch is deduplicated
  const user = await getUser(params.id);

  return (
    <>
      <Header user={await getUser(params.id)} />
      <Profile user={await getUser(params.id)} />
    </>
  );
}
```

### Cache Control

```tsx
// Force dynamic rendering (no cache)
export const dynamic = "force-dynamic";

// Revalidate every 60 seconds
export const revalidate = 60;

// Force static rendering
export const dynamic = "force-static";
```

### Per-Request Caching

```tsx
import { unstable_cache } from "next/cache";

const getCachedUser = unstable_cache(
  async (id: string) => {
    return await db.user.findUnique({ where: { id } });
  },
  ["user"], // cache key
  {
    tags: ["user"],
    revalidate: 60,
  }
);

export default async function Page({ params }: { params: { id: string } }) {
  const user = await getCachedUser(params.id);
  return <Profile user={user} />;
}
```

### Revalidation

```tsx
// Revalidate by path
import { revalidatePath } from "next/cache";

export async function updateUser(data: UserData) {
  await db.user.update({ ... });
  revalidatePath("/users");
  revalidatePath("/users/[id]");
}

// Revalidate by tag
import { revalidateTag } from "next/cache";

export async function updateUser(data: UserData) {
  await db.user.update({ ... });
  revalidateTag("user");
}
```

---

## Error Handling

### Error Boundaries

```tsx
// error.tsx (must be Client Component)
"use client";

export default function Error({
  error,
  reset,
}: {
  error: Error & { digest?: string };
  reset: () => void;
}) {
  return (
    <div>
      <h2>Something went wrong!</h2>
      <p>{error.message}</p>
      <button onClick={reset}>Try again</button>
    </div>
  );
}
```

### Not Found

```tsx
// not-found.tsx
export default function NotFound() {
  return (
    <div>
      <h2>Not Found</h2>
      <p>Could not find the requested resource</p>
    </div>
  );
}

// Trigger from server component
import { notFound } from "next/navigation";

export default async function Page({ params }: { params: { id: string } }) {
  const user = await getUser(params.id);

  if (!user) {
    notFound();
  }

  return <Profile user={user} />;
}
```

---

## Layout Patterns

### Nested Layouts

```tsx
// app/layout.tsx (Root layout)
export default function RootLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <html lang="en">
      <body>
        <Header />
        {children}
        <Footer />
      </body>
    </html>
  );
}

// app/dashboard/layout.tsx (Nested layout)
export default function DashboardLayout({
  children,
}: {
  children: React.ReactNode;
}) {
  return (
    <div className="flex">
      <Sidebar />
      <main>{children}</main>
    </div>
  );
}
```

### Parallel Routes

```tsx
// app/@modal/login/page.tsx
export default function LoginModal() {
  return (
    <Modal>
      <LoginForm />
    </Modal>
  );
}

// app/layout.tsx
export default function Layout({
  children,
  modal,
}: {
  children: React.ReactNode;
  modal: React.ReactNode;
}) {
  return (
    <>
      {children}
      {modal}
    </>
  );
}
```

### Intercepting Routes

```tsx
// app/feed/@modal/(..)photo/[id]/page.tsx
// Intercepts /photo/[id] when navigating from /feed

export default function PhotoModal({ params }: { params: { id: string } }) {
  return (
    <Modal>
      <Photo id={params.id} />
    </Modal>
  );
}
```

---

## Performance Tips

### 1. Keep Client Components Small

```tsx
// ❌ Bad: Entire form is client
"use client";
export function ProductPage() {
  const [quantity, setQuantity] = useState(1);
  // ... lots of server data that could be RSC
}

// ✅ Good: Only interactive part is client
// ProductPage.tsx (Server Component)
export async function ProductPage({ id }) {
  const product = await getProduct(id);
  return (
    <div>
      <ProductDetails product={product} />
      <AddToCartButton productId={id} />  {/* Client */}
    </div>
  );
}
```

### 2. Move State Down

```tsx
// ❌ Bad: State at top forces entire tree to be client
"use client";
function Dashboard() {
  const [selectedId, setSelectedId] = useState(null);
  return (
    <div>
      <Sidebar onSelect={setSelectedId} />
      <Content selectedId={selectedId} />
    </div>
  );
}

// ✅ Good: State isolated in client component
// Dashboard.tsx (Server)
async function Dashboard() {
  const data = await getData();
  return (
    <DashboardShell data={data}>
      <SelectableContent /> {/* Client, contains state */}
    </DashboardShell>
  );
}
```

### 3. Avoid Prop Drilling Through Client Boundary

```tsx
// ❌ Bad: Passing large objects through client boundary
<ClientComponent data={hugeDataObject} />

// ✅ Good: Fetch in server, pass minimal data
async function Page() {
  const data = await getData();
  return (
    <ServerDisplay data={data} />
    <ClientInteraction id={data.id} /> {/* Only pass ID */}
  );
}
```

### 4. Use Loading UI

```tsx
// loading.tsx
export default function Loading() {
  return <Skeleton />;
}

// Or inline with Suspense
<Suspense fallback={<Skeleton />}>
  <SlowComponent />
</Suspense>
```
