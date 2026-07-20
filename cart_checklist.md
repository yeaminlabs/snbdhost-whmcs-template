# SNBD Host Cart & Store Checklist

Use this checklist to track your review of each template page in the custom `snbdhost_cart` order form template.

## 1. The Checkout Flow Steps
- [x] **Product Group Selection (Hosting Plans)**
  - **File**: [products.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/products.tpl)
  - **URL**: `cart.php`
- [x] **Product Domain Selection Step**
  - **File**: [configureproductdomain.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/configureproductdomain.tpl)
  - **URL**: `cart.php?a=add&pid=<pid>`
- [x] **Configure Product (Billing Cycle & Addons)**
  - **File**: [configureproduct.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/configureproduct.tpl)
  - **URL**: `cart.php?a=confproduct&i=0`
- [x] **Configure Domains (Nameservers & DNS)**
  - **File**: [configuredomains.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/configuredomains.tpl)
  - **URL**: `cart.php?a=confdomains`
- [x] **View Cart (Review Items & Promo Code)**
  - **File**: [viewcart.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/viewcart.tpl)
  - **URL**: `cart.php?a=view`
- [x] **Checkout (Client Registration & Gateway)**
  - **File**: [checkout.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/checkout.tpl)
  - **URL**: `cart.php?a=checkout`
- [x] **Order Complete (Receipt Page)**
  - **File**: [complete.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/complete.tpl)
  - **URL**: `cart.php?a=complete`

## 2. Standalone Store Actions
- [x] **Register Domain Standalone**
  - **File**: [domainregister.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/domainregister.tpl)
  - **URL**: `cart.php?a=add&domain=register`
- [x] **Transfer Domain Standalone**
  - **File**: [domaintransfer.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/domaintransfer.tpl)
  - **URL**: `cart.php?a=add&domain=transfer`
- [x] **Service & Product Renewals**
  - **File**: [service-renewals.tpl](file:///e:/snbd_website/snbd-theme/templates/orderforms/snbdhost_cart/service-renewals.tpl)
  - **URL**: `cart.php?a=renewals`
