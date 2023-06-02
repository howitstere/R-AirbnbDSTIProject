# R-AirbnbDSTIProject
## R Markdown Project using Airbnb data
### Abstract
The project aims at analyzing Airbnb data regarding the city of Paris, the data was provided into two separate dataframes “L” and “R”. The dataframes have been saved as two separate csv files as “AirbnbL” and “AirbnbR” and reloaded from the file. AirbnbL dataset has 95 variables and 52725 observations, while AirbnbR dataset has 2 variables and 663599 observations.
AirbnbL has many missing values (279634), while AirbnbR doesn’t present missingness.

AirbnbL variables description:
From the name of the columns and from the data of the two first rows we can understand what each column describe. The variables can be divided into 9 macro categories as follows:

– Identification related columns:

id: Unique identifier for each Airbnb listing / accommodation.

listing_url: URL link to the listing on the Airbnb website.

scrape_id: Unique identifier for the scraping process.

last_scraped: Date when the listing was last scraped.

– Description related columns:

name: Name/title of the listing.

summary: Brief summary description of the accommodation.

space: Description of the space within the listing.

description: Detailed description of the accommodation.

experiences_offered: Information about the experiences offered by the host.

neighborhood_overview: Overview of the neighborhood where the accommodation is located.

notes: Additional notes provided by the host.

transit: Information about transportation options.

access: Information about how to access the accommodation.

interaction: Details about the interaction between the host and guests.

house_rules: Rules set by the host for guests staying.

thumbnail_url: URL link to a thumbnail image of the listing.

medium_url: URL link to a medium-sized image of the listing.

picture_url: URL link to the main picture of the listing.

xl_picture_url: URL link to an extra-large picture of the listing.

– Host related columns:

host_id: Unique identifier for the host.

host_url: URL link to the host’s profile on Airbnb.

host_name: Name of the host.

host_since: Date when the host joined Airbnb.

host_location: Location of the host.

host_about: Information about the host provided by themselves.

host_response_time: Time taken by the host to respond to requests.

host_response_rate: Percentage of requests to which the host has responded.

host_acceptance_rate: Percentage of booking requests accepted by the host.

host_is_superhost: Indicator variable (T/F) if the host is a superhost.

host_thumbnail_url: URL link to the host’s thumbnail profile picture.

host_picture_url: URL link to the host’s profile picture.

host_neighbourhood: Neighborhood where the host lives.

host_listings_count: Total number of accommodations owned by the host.

host_total_listings_count: Same as host_listings_count.

host_verifications: Methods used by the host to verify their identity.

host_has_profile_pic: Indicator variable (T/F) if the host has a profile picture.

host_identity_verified: Indicator variable (T/F) if the host’s identity is verified.

calculated_host_listings_count: Number of listings by the host.

– Location related columns:

street: Address of the accommodation.

neighbourhood: Neighbourhood name of the accommodation.

neighbourhood_cleansed: Cleaned column neighbourhood name.

neighbourhood_group_cleansed: Cleaned column neighbourhood group name.

city: City of the listing.

state: State where the listing is located.

zipcode: Postal code of the listing.

market: Market where the accommodation is located.

smart_location: Smart location name.

country_code: Country code of the accommodation.

country: Country where the listing is located.

latitude: Latitude coordinate of the accommodation.

longitude: Longitude coordinate of the accommodation.

is_location_exact: Indicator variable (T/F) if the location is exact.

– Accommodation details columns:

property_type: Type of property (e.g., apartment, house, etc.).

room_type: Type of room available (e.g., entire home, private room, etc.).

accommodates: Maximum number of guests the accommodation can accommodate.

bathrooms: Number of bathrooms.

bedrooms: Number of bedrooms.

beds: Number of beds.

bed_type: Type of bed (e.g., real bed, sofa bed, etc.).

amenities: List of amenities provided in the listing.

square_feet: Area of the listing in square feet.

– Price related columns:

price: Price per night for the accommodation.

weekly_price: Weekly price for the accommodation.

monthly_price: Monthly price for the accommodation.

security_deposit: Amount of security deposit required.

cleaning_fee: Fee charged for cleaning the accommodation.


guests_included: Number of guests included in the base price.

extra_people: Fee charged for additional guests.

– Calendar and Time related columns:

minimum_nights: Minimum number of nights required for booking.

maximum_nights: Maximum number of nights allowed for booking.

calendar_updated: Information about when the calendar was last updated.

has_availability: Indicator variable (T/F) if the listing has availability.

availability_30: Number of available days within the next 30 days.

availability_60: Number of available days within the next 60 days.

availability_90: Number of available days within the next 90 days.

availability_365: Number of available days within the next 365 days.

calendar_last_scraped: Date when the calendar was last scraped.

– Reviews related columns:

number_of_reviews: Total number of reviews for the accommodation.

first_review: Date of the first review (less recent).

last_review: Date of the most recent review.

review_scores_rating: Rating score based on guest reviews.

review_scores_accuracy: Rating score for accuracy based on guest reviews.

review_scores_cleanliness: Rating score for cleanliness based on guest reviews.

review_scores_checkin: Rating score for check-in process based on guest reviews.

review_scores_communication: Rating score for communication based on guest reviews.

review_scores_location: Rating score for location based on guest reviews.

review_scores_value: Rating score for value based on guest reviews.

reviews_per_month: Average number of reviews received per month.

– Policies related columns:

requires_license: Indicator variable (T/F) if a license is required.

license: License information.

jurisdiction_names: Names of jurisdictions.

instant_bookable: Indicator variable (T/F) if instant booking is available.

cancellation_policy: Policy for canceling bookings.

require_guest_profile_picture: Indicator variable (T/F) if guest profile picture is required.

require_guest_phone_verification: Indicator variable (T/F) if guest phone verification is required.


### Contents:

Analyzing AirbnbL

  Assigning the right datatypes
  
    Converting character values into date format
    
    Converting character values into numeric format removing the % symbol
    
    Converting character values into numeric format removing the $ symbol
    
  Missingness and duplicates
  
    Missingness
 
    Duplicates
 
 Analysis of data according to datatype
 
  Categorical data
  Price related data
  Location related data

Analyzing AirbnbR

  Time related data

Merging AirbnbR and AirbnbL


  
  
  
  
  
  
