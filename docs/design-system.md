# Design System Documentation

## Overview

This document outlines the design system for WhatsDesigns, including UI components, styling guidelines, and design principles.

## Design Principles

### 1. Simplicity
- Clean, minimalist interface
- Clear visual hierarchy
- Intuitive navigation
- Reduced cognitive load

### 2. Consistency
- Uniform component styling
- Standardized spacing
- Consistent typography
- Predictable interactions

### 3. Accessibility
- WCAG 2.1 compliance
- High contrast ratios
- Keyboard navigation
- Screen reader support

### 4. Responsiveness
- Mobile-first approach
- Fluid layouts
- Adaptive components
- Touch-friendly interfaces

## Color System

### Primary Colors
```css
--primary-50: #f0f9ff;
--primary-100: #e0f2fe;
--primary-200: #bae6fd;
--primary-300: #7dd3fc;
--primary-400: #38bdf8;
--primary-500: #0ea5e9;
--primary-600: #0284c7;
--primary-700: #0369a1;
--primary-800: #075985;
--primary-900: #0c4a6e;
```

### Secondary Colors
```css
--secondary-50: #f8fafc;
--secondary-100: #f1f5f9;
--secondary-200: #e2e8f0;
--secondary-300: #cbd5e1;
--secondary-400: #94a3b8;
--secondary-500: #64748b;
--secondary-600: #475569;
--secondary-700: #334155;
--secondary-800: #1e293b;
--secondary-900: #0f172a;
```

### Semantic Colors
```css
--success: #22c55e;
--warning: #f59e0b;
--error: #ef4444;
--info: #3b82f6;
```

## Typography

### Font Family
```css
--font-sans: 'Inter', system-ui, -apple-system, sans-serif;
--font-mono: 'JetBrains Mono', monospace;
```

### Font Sizes
```css
--text-xs: 0.75rem;    /* 12px */
--text-sm: 0.875rem;   /* 14px */
--text-base: 1rem;     /* 16px */
--text-lg: 1.125rem;   /* 18px */
--text-xl: 1.25rem;    /* 20px */
--text-2xl: 1.5rem;    /* 24px */
--text-3xl: 1.875rem;  /* 30px */
--text-4xl: 2.25rem;   /* 36px */
```

### Font Weights
```css
--font-light: 300;
--font-normal: 400;
--font-medium: 500;
--font-semibold: 600;
--font-bold: 700;
```

## Spacing System

### Base Unit
```css
--spacing-unit: 0.25rem;  /* 4px */
```

### Spacing Scale
```css
--spacing-0: 0;
--spacing-1: 0.25rem;   /* 4px */
--spacing-2: 0.5rem;    /* 8px */
--spacing-3: 0.75rem;   /* 12px */
--spacing-4: 1rem;      /* 16px */
--spacing-5: 1.25rem;   /* 20px */
--spacing-6: 1.5rem;    /* 24px */
--spacing-8: 2rem;      /* 32px */
--spacing-10: 2.5rem;   /* 40px */
--spacing-12: 3rem;     /* 48px */
--spacing-16: 4rem;     /* 64px */
```

## Components

### Buttons

#### Primary Button
```tsx
<Button variant="primary">
  Primary Action
</Button>
```

#### Secondary Button
```tsx
<Button variant="secondary">
  Secondary Action
</Button>
```

#### Icon Button
```tsx
<Button variant="icon">
  <Icon name="plus" />
</Button>
```

### Forms

#### Input Field
```tsx
<Input
  label="Email"
  type="email"
  placeholder="Enter your email"
/>
```

#### Select Field
```tsx
<Select
  label="Country"
  options={countries}
  placeholder="Select a country"
/>
```

#### Checkbox
```tsx
<Checkbox
  label="Accept terms"
  checked={accepted}
  onChange={handleChange}
/>
```

### Cards

#### Basic Card
```tsx
<Card>
  <CardHeader>Title</CardHeader>
  <CardBody>Content</CardBody>
  <CardFooter>Actions</CardFooter>
</Card>
```

#### Image Card
```tsx
<Card variant="image">
  <CardImage src="/image.jpg" alt="Description" />
  <CardContent>
    <CardTitle>Title</CardTitle>
    <CardDescription>Description</CardDescription>
  </CardContent>
</Card>
```

### Navigation

#### Navbar
```tsx
<Navbar>
  <NavbarBrand>Logo</NavbarBrand>
  <NavbarLinks>
    <NavLink href="/">Home</NavLink>
    <NavLink href="/projects">Projects</NavLink>
    <NavLink href="/settings">Settings</NavLink>
  </NavbarLinks>
  <NavbarActions>
    <UserMenu />
  </NavbarActions>
</Navbar>
```

#### Breadcrumbs
```tsx
<Breadcrumbs>
  <BreadcrumbItem href="/">Home</BreadcrumbItem>
  <BreadcrumbItem href="/projects">Projects</BreadcrumbItem>
  <BreadcrumbItem>Current Page</BreadcrumbItem>
</Breadcrumbs>
```

## Layout

### Grid System
```css
--grid-columns: 12;
--grid-gap: 1rem;
```

### Breakpoints
```css
--breakpoint-sm: 640px;
--breakpoint-md: 768px;
--breakpoint-lg: 1024px;
--breakpoint-xl: 1280px;
--breakpoint-2xl: 1536px;
```

### Container
```css
--container-sm: 640px;
--container-md: 768px;
--container-lg: 1024px;
--container-xl: 1280px;
```

## Animations

### Transitions
```css
--transition-fast: 150ms ease;
--transition-normal: 250ms ease;
--transition-slow: 350ms ease;
```

### Keyframes
```css
@keyframes fadeIn {
  from { opacity: 0; }
  to { opacity: 1; }
}

@keyframes slideIn {
  from { transform: translateY(20px); opacity: 0; }
  to { transform: translateY(0); opacity: 1; }
}
```

## Icons

### Icon System
- Material Design Icons
- Custom SVG icons
- Icon sizes:
  ```css
  --icon-sm: 1rem;
  --icon-md: 1.5rem;
  --icon-lg: 2rem;
  ```

## Shadows

### Shadow Scale
```css
--shadow-sm: 0 1px 2px 0 rgb(0 0 0 / 0.05);
--shadow-md: 0 4px 6px -1px rgb(0 0 0 / 0.1);
--shadow-lg: 0 10px 15px -3px rgb(0 0 0 / 0.1);
--shadow-xl: 0 20px 25px -5px rgb(0 0 0 / 0.1);
```

## Best Practices

### Component Usage
1. Use semantic HTML elements
2. Maintain consistent spacing
3. Follow accessibility guidelines
4. Implement responsive design
5. Use appropriate animations

### Code Style
1. Use TypeScript for type safety
2. Follow component composition
3. Implement proper prop types
4. Use CSS modules for styling
5. Maintain consistent naming

### Performance
1. Optimize images
2. Lazy load components
3. Minimize bundle size
4. Use proper caching
5. Implement code splitting

## Resources

### Design Tools
- Figma
- Adobe XD
- Sketch

### Documentation
- [Tailwind CSS](https://tailwindcss.com/docs)
- [Material Design](https://material.io/design)
- [Human Interface Guidelines](https://developer.apple.com/design/human-interface-guidelines)

### Accessibility
- [WCAG 2.1](https://www.w3.org/WAI/WCAG21/quickref/)
- [ARIA](https://www.w3.org/WAI/ARIA/apg/)
- [Color Contrast](https://webaim.org/resources/contrastchecker/) 