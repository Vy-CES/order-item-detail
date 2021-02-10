package com.liferay.commerce.demo.order.line.item.checkout;

import com.liferay.commerce.constants.CommerceCheckoutWebKeys;
import com.liferay.commerce.demo.order.line.item.checkout.display.context.OrderLineDetailCheckoutStepDisplayContext;
import com.liferay.commerce.model.CommerceOrder;
import com.liferay.commerce.model.CommerceOrderItem;
import com.liferay.commerce.order.CommerceOrderHttpHelper;
import com.liferay.commerce.product.option.CommerceOptionValueHelper;
import com.liferay.commerce.product.service.CommerceChannelLocalService;
import com.liferay.commerce.product.util.CPInstanceHelper;
import com.liferay.commerce.service.CommerceAddressLocalService;
import com.liferay.commerce.service.CommerceOrderItemLocalService;
import com.liferay.commerce.util.BaseCommerceCheckoutStep;
import com.liferay.commerce.util.CommerceCheckoutStep;
import com.liferay.frontend.taglib.servlet.taglib.util.JSPRenderer;
import com.liferay.portal.kernel.language.LanguageUtil;
import com.liferay.portal.kernel.util.ParamUtil;
import com.liferay.portal.kernel.util.ResourceBundleUtil;
import org.osgi.service.component.annotations.Component;
import org.osgi.service.component.annotations.Reference;

import javax.portlet.ActionRequest;
import javax.portlet.ActionResponse;
import javax.servlet.ServletContext;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.text.DateFormat;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.List;
import java.util.Locale;
import java.util.ResourceBundle;

/**
 * @author Jeff Handa
 */
@Component(
	immediate = true,
		property = {
				"commerce.checkout.step.name=" + OrderLineDetailCheckoutStep.NAME,
				"commerce.checkout.step.order:Integer=22"
		},
		service = CommerceCheckoutStep.class
)
public class OrderLineDetailCheckoutStep extends BaseCommerceCheckoutStep {

	public static final String NAME = "order-line-detail-checkout-step";

	@Override
	public String getLabel(Locale locale) {
		ResourceBundle resourceBundle = ResourceBundleUtil.getBundle(
				"content.Language", locale, getClass());

		return LanguageUtil.get(resourceBundle, "order-line-item-detail");
	}

	@Override
	public boolean isVisible(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
		return true;
	}

	@Override
	public boolean isActive(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {
		return true;
	}

	@Override
	public String getName() {
		return NAME;
	}

	@Override
	public void processAction(ActionRequest actionRequest, ActionResponse actionResponse) throws Exception {

		CommerceOrder commerceOrder = (CommerceOrder)actionRequest.getAttribute(CommerceCheckoutWebKeys.COMMERCE_ORDER);
		List<CommerceOrderItem> commerceOrderItems = commerceOrder.getCommerceOrderItems();
		for (CommerceOrderItem commerceOrderItem: commerceOrderItems){
			int quantity = ParamUtil.getInteger(actionRequest, Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-quantity");
			long shipToAddressId = ParamUtil.getLong(actionRequest, Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-address");
			DateFormat df = new SimpleDateFormat("MM/dd/yyyy");
			Date requestedDeliveryDate = ParamUtil.getDate(actionRequest, Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-date", df);

			commerceOrderItem.setQuantity(quantity);
			if (commerceOrder.getShippingAddressId() != shipToAddressId){
				commerceOrderItem.setShippingAddressId(shipToAddressId);
			}
			commerceOrderItem.setRequestedDeliveryDate(requestedDeliveryDate);
			_commerceOrderItemLocalService.updateCommerceOrderItem(commerceOrderItem);
		}
	}

	@Override
	public void render(HttpServletRequest httpServletRequest, HttpServletResponse httpServletResponse) throws Exception {

		OrderLineDetailCheckoutStepDisplayContext orderLineDetailCheckoutStepDisplayContext =
				new OrderLineDetailCheckoutStepDisplayContext(_commerceAddressLocalService, _commerceChannelLocalService, _commerceOptionValueHelper,
						_commerceOrderHttpHelper, _cpInstanceHelper, httpServletRequest);

		httpServletRequest.setAttribute("orderLineDetailCheckoutStepDisplayContext", orderLineDetailCheckoutStepDisplayContext);

		_jspRenderer.renderJSP(
				_servletContext, httpServletRequest, httpServletResponse,
				"/order_line_detail_form.jsp");

	}

	@Reference
	private JSPRenderer _jspRenderer;

	@Reference(
			target = "(osgi.web.symbolicname=com.liferay.commerce.demo.order.line.item.checkout)"
	)
	private ServletContext _servletContext;

	@Reference
	private CommerceAddressLocalService _commerceAddressLocalService;
	@Reference
	private CommerceChannelLocalService _commerceChannelLocalService;

	@Reference
	private CommerceOrderItemLocalService _commerceOrderItemLocalService;

	@Reference
	private CommerceOptionValueHelper _commerceOptionValueHelper;

	@Reference
	private CommerceOrderHttpHelper _commerceOrderHttpHelper;

	@Reference
	private CPInstanceHelper _cpInstanceHelper;
}