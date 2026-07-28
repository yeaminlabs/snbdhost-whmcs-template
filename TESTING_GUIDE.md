# SNBD Host WHMCS Theme Testing & Activation Guide

This guide provides step-by-step instructions on how to activate the custom **SNBD Host Theme** and **Order Form Cart Template** in WHMCS, along with a comprehensive checklist of elements to verify.

---

## 1. How to Activate the Theme in WHMCS

### Step A: Activate the Client Area Theme
1. Log in to your WHMCS Admin Area.
2. Navigate to **System Settings** > **General Settings** (or **Configuration** > **System Settings** > **General Settings** in WHMCS v8.x+).
3. Select the **General** tab.
4. Locate the **Template** dropdown.
5. Select `snbdhost` from the list.
6. Click **Save Changes**.

### Step B: Activate the Custom Order Form Template
1. In the WHMCS Admin Area, navigate to **System Settings** > **General Settings**.
2. Select the **Ordering** tab.
3. Locate the **Default Order Form Template** dropdown.
4. Select `snbdhost_cart` from the list.
5. Click **Save Changes**.

---

## 2. What Things to Test

Verify the following items across different screen sizes (desktop, tablet, and mobile):

### A. General Layout & Styles
* [ ] **Navigation & Menus**: Check header navigation links, responsive hamburger toggle menu, and footer layouts.
* [ ] **Design Theme Tokens**: Verify that the primary brand red color (`#BA1114`) renders correctly on key actions, buttons, and badges.
* [ ] **No Console Errors**: Open the browser console (`F12`) and verify that no Javascript exceptions occur (all custom scripts should compile properly within Smarty bounds).

### B. Client Area Dashboard Pages
* [ ] **Dashboard Homepage (`clientarea.php`)**: Ensure that all custom cards, quick info stats, and latest ticket notifications display correctly.
* [ ] **My Services (`clientarea.php?action=products`)**: Verify that active hosting products load inside their grid cells.
* [ ] **My Domains (`clientarea.php?action=domains`)**: Verify that the domain list table supports responsive horizontal scrollbars on mobile viewports.
* [ ] **Invoices List (`clientarea.php?action=invoices`)**: Verify payment statuses, links, and responsive grid reflow.
* [ ] **HTML Invoice View (`viewinvoice.php?id=<id>`)**: Open an invoice and check the branding layout, typography, and payment gateway details.

### C. Support System
* [ ] **Tickets List (`supporttickets.php`)**: Test filtering and responsiveness of the ticket logs.
* [ ] **Ticket Chat Log (`viewticket.php`)**: Check the chat layout, bubble styles, and attachment input buttons.
* [ ] **Server Status (`serverstatus.php`)**: Ensure UptimeRobot API scripts load and display server response metrics dynamically.

### D. Order Form & Checkout Flow (`snbdhost_cart`)
* [ ] **Hosting Plans Selector (`cart.php`)**: Test clicking plan categories. Ensure nav-pills are easy to tap (`44px` height target).
* [ ] **Domain Selection (`cart.php?a=add&pid=X`)**: Test register/transfer/own tabs and search box layouts.
* [ ] **Addons & Cycles (`cart.php?a=confproduct`)**: Verify that the billing cycle dropdown, metrics details, and range sliders (ionRangeSlider) load properly.
* [ ] **View Cart Review (`cart.php?a=view`)**: Check promo code applying alerts, price cycles, and item removals.
* [ ] **Checkout Form (`cart.php?a=checkout`)**: Verify payment method selectors (such as bKash, Nagad, Stripe, PayPal) and popover indicators.

### E. Account Authentication
* [ ] **Login Screen (`login.php`)**: Confirm responsive split-panel design (left side hides on mobile viewports).
* [ ] **Account Registration (`register.php`)**: Test inputs, tooltips, and captcha wrappers.
* [ ] **Password Reset Screens (`pwreset.php`)**: Check reset request and reset confirmation input forms.
