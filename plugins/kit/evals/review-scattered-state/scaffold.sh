set -e
mkdir -p src/cart
cat > package.json <<'J'
{ "name": "shop", "type": "module", "dependencies": { "react": "^19.0.0" } }
J
cat > CLAUDE.md <<'J'
# shop

A React storefront. Each feature lives in `src/<feature>/`.
J
cat > src/cart/useCartItems.js <<'J'
import { useState } from 'react';

export function useCartItems() {
  const [items, setItems] = useState([]);
  const add = (product) => setItems((current) => [...current, { ...product, quantity: 1 }]);
  const remove = (productId) => setItems((current) => current.filter((item) => item.id !== productId));
  return { items, add, remove };
}
J
cat > src/cart/useCartTotals.js <<'J'
import { useMemo } from 'react';

export function useCartTotals(items) {
  return useMemo(() => {
    const subtotal = items.reduce((sum, item) => sum + item.price * item.quantity, 0);
    return { subtotal, count: items.length };
  }, [items]);
}
J
cat > src/cart/useCartDiscount.js <<'J'
import { useState } from 'react';

export function useCartDiscount(subtotal) {
  const [code, setCode] = useState('');
  const discount = code === 'SAVE10' ? Math.round(subtotal * 0.1) : 0;
  return { code, setCode, discount, total: subtotal - discount };
}
J
cat > src/cart/useCartCheckout.js <<'J'
import { useState } from 'react';

export function useCartCheckout(items, total, code) {
  const [isSubmitting, setIsSubmitting] = useState(false);
  const checkout = async () => {
    setIsSubmitting(true);
    await fetch('/api/checkout', { method: 'POST', body: JSON.stringify({ items, total, code }) });
    setIsSubmitting(false);
  };
  return { isSubmitting, checkout };
}
J
cat > src/cart/CartPage.jsx <<'J'
import { useCartItems } from './useCartItems.js';
import { useCartTotals } from './useCartTotals.js';
import { useCartDiscount } from './useCartDiscount.js';
import { useCartCheckout } from './useCartCheckout.js';

export function CartPage() {
  const { items, remove } = useCartItems();
  const { subtotal } = useCartTotals(items);
  const { code, setCode, total } = useCartDiscount(subtotal);
  const { isSubmitting, checkout } = useCartCheckout(items, total, code);
  return (
    <main>
      {items.map((item) => <button key={item.id} onClick={() => remove(item.id)}>{item.name}</button>)}
      <input value={code} onChange={(event) => setCode(event.target.value)} />
      <p>{total}</p>
      <button disabled={isSubmitting} onClick={checkout}>Check out</button>
    </main>
  );
}
J
git init -q && git add -A && git -c user.email=e@x -c user.name=eval commit -qm "base"
cat > src/cart/CartDrawer.jsx <<'J'
import { useCartItems } from './useCartItems.js';
import { useCartTotals } from './useCartTotals.js';
import { useCartDiscount } from './useCartDiscount.js';
import { useCartCheckout } from './useCartCheckout.js';

export function CartDrawer({ onClose }) {
  const { items } = useCartItems();
  const { subtotal, count } = useCartTotals(items);
  const { code, total } = useCartDiscount(subtotal);
  const { isSubmitting, checkout } = useCartCheckout(items, total, code);
  return (
    <aside>
      <p>{count} items, {total}</p>
      <button disabled={isSubmitting} onClick={checkout}>Check out</button>
      <button onClick={onClose}>Close</button>
    </aside>
  );
}
J
