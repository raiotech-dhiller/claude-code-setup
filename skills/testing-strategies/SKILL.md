---
name: testing-strategies
description: |
  Testing strategies for frontend, backend, and E2E testing.
  Use when writing tests, setting up test infrastructure, or debugging test failures.
---

# Testing Strategies

## Test Pyramid
- **Unit Tests**: Fast, isolated, many
- **Integration Tests**: API boundaries, moderate
- **E2E Tests**: User flows, few but critical

## React Testing
```typescript
import { render, screen, fireEvent } from '@testing-library/react';

test('button click updates state', () => {
  render(<Counter />);
  fireEvent.click(screen.getByRole('button'));
  expect(screen.getByText('Count: 1')).toBeInTheDocument();
});
```

## API Testing
```typescript
describe('POST /api/users', () => {
  it('creates user with valid data', async () => {
    const res = await request(app)
      .post('/api/users')
      .send({ name: 'Test', email: 'test@test.com' });
    
    expect(res.status).toBe(201);
    expect(res.body.id).toBeDefined();
  });
});
```

## E2E Testing (Playwright)
```typescript
test('user can complete checkout', async ({ page }) => {
  await page.goto('/products');
  await page.click('[data-testid="add-to-cart"]');
  await page.click('[data-testid="checkout"]');
  await expect(page.locator('.success')).toBeVisible();
});
```

## Test Best Practices
- Test behavior, not implementation
- One assertion per test when possible
- Use descriptive test names
- Avoid test interdependence
- Mock external dependencies
