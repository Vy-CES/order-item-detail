package com.liferay.commerce.demo.order.line.item.checkout.display.context;

import com.liferay.commerce.account.model.CommerceAccount;
import com.liferay.commerce.constants.CommerceCheckoutWebKeys;
import com.liferay.commerce.constants.CommerceWebKeys;
import com.liferay.commerce.context.CommerceContext;
import com.liferay.commerce.model.CommerceAddress;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceOrderItem;
import com.liferay.commerce.order.CommerceOrderHttpHelper;
import com.liferay.commerce.product.option.CommerceOptionValueHelper;
import com.liferay.commerce.product.service.CommerceChannelLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.commerce.service.CommerceAddressLocalService;
import com.liferay.portal.kernel.exception.PortalException;

import javax.servlet.http.HttpServletRequest;
import java.util.List;

public class OrderLineDetailCheckoutStepDisplayContext {

    public OrderLineDetailCheckoutStepDisplayContext(CommerceAddressLocalService commerceAddressLocalService,
                                                     CommerceChannelLocalService commerceChannelLocalService,
                                                     CommerceOptionValueHelper commerceOptionValueHelper,
                                                     CommerceOrderHttpHelper commerceOrderHttpHelper,
                                                     CPInstanceHelper cpInstanceHelper,
                                                     HttpServletRequest httpServletRequest) {
        _commerceAddressLocalService = commerceAddressLocalService;
        _commerceChannelLocalService = commerceChannelLocalService;
        _commerceOptionValueHelper = commerceOptionValueHelper;
        _commerceOrderHttpHelper = commerceOrderHttpHelper;
        _cpInstanceHelper = cpInstanceHelper;
        _commerceContext = (CommerceContext)httpServletRequest.getAttribute(CommerceWebKeys.COMMERCE_CONTEXT);
        _commerceOrder = (CommerceOrder)httpServletRequest.getAttribute(CommerceCheckoutWebKeys.COMMERCE_ORDER);
    }

    public String getCommerceOrderItemThumbnailSrc(
            CommerceOrderItem commerceOrderItem)
            throws Exception {

        return _cpInstanceHelper.getCPInstanceThumbnailSrc(commerceOrderItem.getCommerceOrder().getCommerceAccountId(),
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


    private final CommerceAddressLocalService _commerceAddressLocalService;
    private final CommerceChannelLocalService _commerceChannelLocalService;
    private final CommerceContext _commerceContext;
    private final CommerceOptionValueHelper _commerceOptionValueHelper;
    private final CommerceOrder _commerceOrder;
    private final CommerceOrderHttpHelper _commerceOrderHttpHelper;
    private final CPInstanceHelper _cpInstanceHelper;
}
