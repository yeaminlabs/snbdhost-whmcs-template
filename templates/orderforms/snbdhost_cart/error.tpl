{include file="orderforms/snbdhost_cart/common.tpl"}

<div id="order-standard_cart">

    <div class="row">
        <div class="cart-body">
            <div class="header-lined mb-4 border-0 pb-0">
                    <h1 class="dash-headline" style="font-size: 2rem;">
                    {$LANG.thereisaproblem}
                </h1>
                </div>

            <div class="alert alert-danger error-heading">
                <i class="fas fa-exclamation-triangle"></i>
                {$errortitle}
            </div>

            <div class="row">
                <div class="col-sm-8 col-sm-offset-2 offset-sm-2">

                    <p class="margin-bottom">{$errormsg}</p>

                    <div class="text-center">
                        <a href="javascript:history.go(-1)" class="btn btn-default">
                            <i class="fas fa-arrow-left"></i>&nbsp;
                            {$LANG.problemgoback}
                        </a>
                    </div>

                </div>
            </div>
        </div>
    </div>
</div>
