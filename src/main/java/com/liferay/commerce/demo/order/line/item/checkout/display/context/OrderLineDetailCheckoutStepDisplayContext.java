package com.liferay.commerce.demo.order.line.item.checkout.display.context;

import com.liferay.commerce.account.model.CommerceAccount;
import com.liferay.commerce.constants.CommerceCheckoutWebKeys;
import com.liferay.commerce.constants.CommerceWebKeys;
import com.liferay.commerce.context.CommerceContext;
import com.liferay.commerce.inventory.model.CommerceInventoryWarehouse;
import com.liferay.commerce.inventory.service.CommerceInventoryWarehouseService;
import com.liferay.commerce.model.CommerceAddress;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceOrderItem;
import com.liferay.commerce.order.CommerceOrderHttpHelper;
import com.liferay.commerce.product.option.CommerceOptionValueHelper;
import com.liferay.commerce.product.service.CommerceChannelLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.commerce.service.CommerceAddressLocalService;
import com.liferay.portal.kernel.exception.PortalException;
import com.liferay.portal.kernel.theme.ThemeDisplay;
import com.liferay.portal.kernel.util.WebKeys;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class OrderLineDetailCheckoutStepDisplayContext {

    public OrderLineDetailCheckoutStepDisplayContext(CommerceAddressLocalService commerceAddressLocalService,
                                                     CommerceChannelLocalService commerceChannelLocalService,
                                                     CommerceInventoryWarehouseService commerceInventoryWarehouseService,
                                                     CommerceOptionValueHelper commerceOptionValueHelper,
                                                     CommerceOrderHttpHelper commerceOrderHttpHelper,
                                                     CPInstanceHelper cpInstanceHelper,
                                                     HttpServletRequest httpServletRequest) {
        _commerceAddressLocalService = commerceAddressLocalService;
        _commerceChannelLocalService = commerceChannelLocalService;
        _commerceInventoryWarehouseService = commerceInventoryWarehouseService;
        _commerceOptionValueHelper = commerceOptionValueHelper;
        _commerceOrderHttpHelper = commerceOrderHttpHelper;
        _cpInstanceHelper = cpInstanceHelper;
        _commerceContext = (CommerceContext)httpServletRequest.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
        _commerceOrder = (CommerceOrder)httpServletRequest.getAttribute(CommerceCheckoutWebKeys.COMMERCE_ORDER);
        _themeDisplay = (ThemeDisplay) httpServletRequest.getAttribute(WebKeys.THEME_DISPLAY);
    }

    public String getCommerceOrderItemThumbnailSrc(
            CommerceOrderItem commerceOrderItem)
            throws Exception {

        return _cpInstanceHelper.getCPInstanceThumbnailSrc(
                commerceOrderItem.getCPInstanceId());
    }

    public CommerceOrder getCommerceOrder(){
        return _commerceOrder;
    }

    public List<CommerceAddress> getCommerceAddresses() throws PortalException {
        return _commerceAddressLocalService.getShippingCommerceAddresses(
                _commerceOrder.getCompanyId(), CommerceAccount.class.getName(),
                _commerceOrder.getCommerceAccountId());
    }

    public List<CommerceInventoryWarehouse> getCommerceInventoryWarehouses() throws PortalException {

        return _commerceInventoryWarehouseService.getCommerceInventoryWarehouses(_themeDisplay.getCompanyId(), _commerceContext.getCommerceChannelGroupId(), true);
    }

    private final CommerceAddressLocalService _commerceAddressLocalService;
    private final CommerceChannelLocalService _commerceChannelLocalService;
    private final CommerceInventoryWarehouseService _commerceInventoryWarehouseService;
    private final CommerceContext _commerceContext;
    private final CommerceOptionValueHelper _commerceOptionValueHelper;
    private final CommerceOrder _commerceOrder;
    private final CommerceOrderHttpHelper _commerceOrderHttpHelper;
    private final CPInstanceHelper _cpInstanceHelper;
    private final ThemeDisplay _themeDisplay;
}
