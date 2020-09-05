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
<%@ page import="com.liferay.portal.kernel.util.Constants" %>
<%@ page import="com.liferay.portal.kernel.util.HtmlUtil" %>
<%@ page import="java.util.List" %>
<%@ page import="com.liferay.users.admin.kernel.util.UsersAdminUtil" %>
<%@ page import="com.liferay.portal.kernel.model.Contact" %>
<%@ page import="com.liferay.commerce.model.CommerceAddress" %>
<%@ page import="com.liferay.portal.kernel.util.Validator" %>
<%@ page import="com.liferay.portal.kernel.util.StringPool" %>
<%@ page import="java.util.ArrayList" %>


<liferay-frontend:defineObjects />

<liferay-theme:defineObjects />

<portlet:defineObjects />

<%
	OrderLineDetailCheckoutStepDisplayContext orderLineDetailCheckoutStepDisplayContext =
			(OrderLineDetailCheckoutStepDisplayContext)request.getAttribute("orderLineDetailCheckoutStepDisplayContext");
	CommerceOrder commerceOrder = orderLineDetailCheckoutStepDisplayContext.getCommerceOrder();
	long commerceOrderShippingAddressId = commerceOrder.getShippingAddressId();
	List<CommerceOrderItem> commerceOrderItems = commerceOrder.getCommerceOrderItems();
	List<CommerceAddress> commerceAddresses = orderLineDetailCheckoutStepDisplayContext.getCommerceAddresses();

%>



<portlet:actionURL name="saveOrderLineItemDetails" var="saveOrderLineItemDetailsActionURL"/>

<aui:form action="<%= saveOrderLineItemDetailsActionURL %>" data-senna-off="true" method="post" name="fm">

	<aui:input name="<%= Constants.CMD %>" type="hidden" value="<%= Constants.UPDATE %>" />

	<div class="commerce-checkout-summary-body" id="<portlet:namespace />entriesContainer">
	<liferay-ui:search-container
			cssClass="list-group-flush"
			id="commerceOrderItems"
	>
		<liferay-ui:search-container-results
				results="<%= commerceOrder.getCommerceOrderItems() %>"
		/>

		<liferay-ui:search-container-row
				className="com.liferay.commerce.model.CommerceOrderItem"
				cssClass="entry-display-style"
				keyProperty="CommerceOrderItemId"
				modelVar="commerceOrderItem"
		>

			<%
				CPDefinition cpDefinition = commerceOrderItem.getCPDefinition();
				String quantityFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-quantity";
				String addressFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-address";
				String dateFormFieldName = Long.toString(commerceOrderItem.getCommerceOrderItemId()) + "-date";
			%>

			<liferay-ui:search-container-column-image
					cssClass="thumbnail-section"
					name="image"
					src="<%= orderLineDetailCheckoutStepDisplayContext.getCommerceOrderItemThumbnailSrc(commerceOrderItem) %>"
			/>

			<liferay-ui:search-container-column-text
					cssClass="autofit-col-expand"
					name="product"
			>
				<div class="description-section">
					<div class="list-group-title">
						<%= HtmlUtil.escape(cpDefinition.getName(themeDisplay.getLanguageId())) %>
					</div>
				</div>
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
<%--				</c:if>--%>

			</liferay-ui:search-container-column-text>

			<liferay-ui:search-container-column-text
					name="requested-delivery-date"
			>

				<aui:input label=""
						   bean="<%= commerceOrderItem %>"
						   model="<%= CommerceOrderItem.class %>"
						   name="requestedDeliveryDate"
						   value="<%= commerceOrderItem.getRequestedDeliveryDate() %>"  />

			</liferay-ui:search-container-column-text>

		</liferay-ui:search-container-row>

		<liferay-ui:search-iterator
				displayStyle="list"
				markupView="lexicon"
				paginate="<%= false %>"
		/>
	</liferay-ui:search-container>

</aui:form>
</div>

