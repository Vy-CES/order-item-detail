# Order Item Detail Widget

![Freelancer](doc/preview.gif
)

## Usage

This module allows you to update several details on individual order items during checkout.  These fields are part
of the Commerce data model, but are not exposed through the standard UI.  This widget adds a new checkout step and 
persists any data entered, however it does not update the Order Summary or Order Confirmation screens so to confirm the 
order line details it's recommended you check the order through the REST API.       

## Requirements

- Liferay Commerce 2.1.2

## Installation

- Download the `.jar` file in [releases](https://github.com/jhanda/OrderItemDetail/releases/tag/1.0.0) and deploy it into Liferay.

or

- Clone this repository, add it to a Liferay workspace and deploy it into Liferay.


## License

[MIT](LICENSE)