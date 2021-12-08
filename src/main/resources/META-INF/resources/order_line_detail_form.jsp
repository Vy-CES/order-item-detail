<%@ taglib prefix="aui" uri="http://liferay.com/tld/aui" %>
<%@ taglib prefix="portlet" uri="http://java.sun.com/portlet_2_0" %>

<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<%@ taglib uri="http://liferay.com/tld/commerce-ui" prefix="commerce-ui" %>
<%@ taglib uri="http://liferay.com/tld/frontend" prefix="liferay-frontend" %>
<%@ taglib uri="http://liferay.com/tld/theme" prefix="liferay-theme" %>
<%@ taglib uri="http://liferay.com/tld/ui" prefix="liferay-ui" %>

<%@ page import="com.liferay.commerce.demo.order.line.item.checkout.display.context.OrderLineDetailCheckoutStepDisplayContext " %>
<%@ page import="com.liferay.commerce.model.CommerceOrder" %>
<%@ page import="com.liferay.commerce.model.CommerceOrderItem" %>
<%@ page import="com.liferay.commerce.product.model.CPDefinition" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liferay.commerce.model.CommerceAddress" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="com.liferay.portal.kernel.util.*" %>
<%@ page import="java.util.Date" %>
<%@ page import="com.liferay.commerce.inventory.model.CommerceInventoryWarehouse" %>
<%@ page import="com.liferay.commerce.demo.order.line.item.checkout.constants.OrderLineDetailCheckoutStepConstants" %>

<liferay-frontend:defineObjects />

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%
	OrderLineDetailCheckoutStepDisplayContext orderLineDetailCheckoutStepDisplayContext =
			(OrderLineDetailCheckoutStepDisplayContext)request.getAttribute("orderLineDetailCheckoutStepDisplayContext");
	CommerceOrder commerceOrder = orderLineDetailCheckoutStepDisplayContext.getCommerceOrder();
	List<CommerceOrderItem> commerceOrderItems = commerceOrder.getCommerceOrderItems();
	List<CommerceAddress> commerceAddresses = orderLineDetailCheckoutStepDisplayContext.getCommerceAddresses();
	List<CommerceInventoryWarehouse> commerceInventoryWarehouses = orderLineDetailCheckoutStepDisplayContext.getCommerceInventoryWarehouses();
%>

<portlet:actionURL name="saveOrderLineItemDetails" var="saveOrderLineItemDetailsActionURL"/>

<aui:form action="<%= saveOrderLineItemDetailsActionURL %>" data-senna-off="true" method="post" name="fm">

	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />

	<liferay-ui:search-container
			cssClass="list-group-flush"
			id="commerceOrderItems"
	>
		<liferay-ui:search-container-results
				results="<%= commerceOrderItems %>"
		/>

		<liferay-ui:search-container-row
				className="com.liferay.commerce.model.CommerceOrderItem"
				cssClass="entry-display-style"
				keyProperty="CommerceOrderItemId"
				modelVar="commerceOrderItem"
		>

			<%
				CPDefinition cpDefinition = commerceOrderItem.getCPDefinition();
				Date requestedDeliveryDate = commerceOrderItem.getRequestedDeliveryDate();

				String quantityFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-quantity";
				String addressFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-address";
				String dateFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-date";
				String warehouseFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-warehouse";

				long preferredWarehouseId = GetterUtil.getLong(commerceOrderItem.getExpandoBridge().getAttribute(OrderLineDetailCheckoutStepConstants.WAREHOUSE));

				int requestedDeliveryDay = 0;
				int requestedDeliveryMonth = -1;
				int requestedDeliveryYear = 0;

				if (requestedDeliveryDate != null) {
					Calendar calendar = CalendarFactoryUtil.getCalendar(requestedDeliveryDate.getTime());

					requestedDeliveryDay = calendar.get(Calendar.DAY_OF_MONTH);
					requestedDeliveryMonth = calendar.get(Calendar.MONTH);
					requestedDeliveryYear = calendar.get(Calendar.YEAR);
				}
			%>

			<liferay-ui:search-container-column-image
					cssClass="thumbnail-section"
					name="image"
					src="<%= orderLineDetailCheckoutStepDisplayContext.getCommerceOrderItemThumbnailSrc(commerceOrderItem) %>"
			/>

			<liferay-ui:search-container-column-text
					cssClass="autofit-col-expand list-group-title"
					name="product"
			>
						<%= HtmlUtil.escape(cpDefinition.getName(themeDisplay.getLanguageId())) %>

			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
					name="quantity"
			>

				<aui:input label=""
						   name="<%= quantityFormFieldName %>"
						   value="<%= Integer.toString(commerceOrderItem.getQuantity()) %>"  />
			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
					name="ship-to"
			>
				<%
					if(commerceOrderItem.getShippingAddressId() == 0){
						commerceOrderItem.setShippingAddressId(commerceOrder.getShippingAddressId());
					}
				%>
					<aui:select  label=""  name="<%= addressFormFieldName %>" >
						<aui:option label="use-order-address" value="0" />

						<%
							for (CommerceAddress commerceAddress : commerceAddresses) {
								boolean selectedAddress = commerceOrderItem.getShippingAddressId() == commerceAddress.getCommerceAddressId();
						%>

						<aui:option data-name="<%= HtmlUtil.escapeAttribute(commerceAddress.getName()) %>"
									label="<%= commerceAddress.getName() %>"
									selected="<%= selectedAddress %>"
									value="<%= commerceAddress.getCommerceAddressId() %>" />

						<%
							}
						%>

					</aui:select>

			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
					name="preferred-warehouse"
			>
				<aui:select  label=""  name="<%= warehouseFormFieldName %>" >
					<aui:option label="use-assigned-warehouse" value="0" />

					<%
						for (CommerceInventoryWarehouse commerceInventoryWarehouse : commerceInventoryWarehouses) {
							boolean selectedWarehouse = preferredWarehouseId == commerceInventoryWarehouse.getCommerceInventoryWarehouseId();

					%>

					<aui:option data-name="<%= HtmlUtil.escapeAttribute(commerceInventoryWarehouse.getName()) %>"
								label="<%= commerceInventoryWarehouse.getName() %>"
								selected="<%= selectedWarehouse %>"
								value="<%= commerceInventoryWarehouse.getCommerceInventoryWarehouseId() %>" />

					<%
						}
					%>

				</aui:select>

			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
					name="requested-delivery-date"
			>
				<div class="form-group input-select-wrapper">

					<liferay-ui:input-date
							dayParam="requestedDeliveryDateDay"
							dayValue="<%= requestedDeliveryDay %>"
							disabled="<%= false %>"
							monthParam="requestedDeliveryDateMonth"
							monthValue="<%= requestedDeliveryMonth %>"
							name="<%= dateFormFieldName%>"
							nullable="<%= true %>"
							showDisableCheckbox="<%= false %>"
							yearParam="requestedDeliveryDateYear"
							yearValue="<%= requestedDeliveryYear %>"
					/>
				</div>
			</liferay-ui:search-container-column-text>

		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator
				displayStyle="list"
				markupView="lexicon"
				paginate="<%= false %>"
		/>

	</liferay-ui:search-container>

</aui:form>

