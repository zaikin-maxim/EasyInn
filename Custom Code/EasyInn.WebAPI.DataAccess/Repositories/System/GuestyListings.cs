using System;

namespace EasyInn.WebAPI.DataAccess.Repositories
{

    public class GuestyListings
    {
        public Result[] results { get; set; }
        public string title { get; set; }
        public int count { get; set; }
        public string fields { get; set; }
        public int limit { get; set; }
        public int skip { get; set; }
    }

    public class Result
    {
        public string _id { get; set; }
        public int accommodates { get; set; }
        public int bedrooms { get; set; }
        public int beds { get; set; }
        public float bathrooms { get; set; }
        public string defaultCheckInTime { get; set; }
        public string defaultCheckOutTime { get; set; }
        public string propertyType { get; set; }
        public string roomType { get; set; }
        public string timezone { get; set; }
        public string nickname { get; set; }
        public string title { get; set; }
        public string accountId { get; set; }
        public Occupancystat[] occupancyStats { get; set; }
        public object[] preBooking { get; set; }
        public DateTime importedAt { get; set; }
        public object[] offeredServices { get; set; }
        public Calendarrules calendarRules { get; set; }
        public Customfield[] customFields { get; set; }
        public bool active { get; set; }
        public Receptionistsservice receptionistsService { get; set; }
        public Sales sales { get; set; }
        public Pms pms { get; set; }
        public bool useAccountMarkups { get; set; }
        public Markups markups { get; set; }
        public bool useAccountTaxes { get; set; }
        public object[] taxes { get; set; }
        public string ownerRevenueFormula { get; set; }
        public string commissionFormula { get; set; }
        public string netIncomeFormula { get; set; }
        public bool useAccountRevenueShare { get; set; }
        public Prices prices { get; set; }
        public Terms terms { get; set; }
        public string[] amenitiesNotIncluded { get; set; }
        public string[] amenities { get; set; }
        public Picture1[] pictures { get; set; }
        public Picture picture { get; set; }
        public Address address { get; set; }
        public Listingroom[] listingRooms { get; set; }
        public string[] owners { get; set; }
        public string[] tags { get; set; }
        public Pendingtask[] pendingTasks { get; set; }
        public Integration[] integrations { get; set; }
        public Saas SaaS { get; set; }
        public string type { get; set; }
        public DateTime lastUpdatedAt { get; set; }
        public DateTime createdAt { get; set; }
        public int __v { get; set; }
        public DateTime lastActivityAt { get; set; }
        public Cleaningstatus1 cleaningStatus { get; set; }
        public bool useAccountAdditionalFees { get; set; }
        public bool isListed { get; set; }
        public object[] accountTaxes { get; set; }
        public DateTime lastSyncedAt { get; set; }
        public string bedType { get; set; }
        public string importingPlatform { get; set; }
        public Publicdescription publicDescription { get; set; }
        public Instantbookable instantBookable { get; set; }
        public Channelslisted channelsListed { get; set; }
        public int areaSquareFeet { get; set; }
        public string contactPhone { get; set; }
        public Privatedescription privateDescription { get; set; }
        public Cleaning cleaning { get; set; }
        public Postbookingservice postBookingService { get; set; }
    }

    public class Calendarrules
    {
        public string defaultAvailability { get; set; }
        public Seasonalminnight[] seasonalMinNights { get; set; }
        public object[] rentalPeriods { get; set; }
        public int weekendMinNights { get; set; }
        public Advancenotice advanceNotice { get; set; }
        public Bookingwindow bookingWindow { get; set; }
    }

    public class Advancenotice
    {
    }

    public class Bookingwindow
    {
    }

    public class Seasonalminnight
    {
        public string _id { get; set; }
        public string from { get; set; }
        public string to { get; set; }
        public int minNights { get; set; }
    }

    public class Receptionistsservice
    {
        public Receptiondesk receptionDesk { get; set; }
        public Screening screening { get; set; }
        public bool active { get; set; }
    }

    public class Receptiondesk
    {
        public object[] atPhones { get; set; }
        public object[] ittt { get; set; }
    }

    public class Screening
    {
        public object[] checklist { get; set; }
    }

    public class Sales
    {
        public Salesservice salesService { get; set; }
    }

    public class Salesservice
    {
        public object[] atPhones { get; set; }
    }

    public class Pms
    {
        public Automation automation { get; set; }
        public Tasks tasks { get; set; }
        public Autopayments autoPayments { get; set; }
        public bool active { get; set; }
        public Cleaningstatus cleaningStatus { get; set; }
    }

    public class Automation
    {
        public Answeringmachine answeringMachine { get; set; }
        public Hooks hooks { get; set; }
        public Calendarsmartrules calendarSmartRules { get; set; }
        public Autoreviews autoReviews { get; set; }
        public Autopricing autoPricing { get; set; }
        public Homeautomation homeAutomation { get; set; }
        public Autolist autoList { get; set; }
    }

    public class Answeringmachine
    {
        public Confirmedbeforecheckin confirmedBeforeCheckIn { get; set; }
        public Confirmeddayofcheckin confirmedDayOfCheckIn { get; set; }
        public Confirmeddayofcheckout confirmedDayOfCheckOut { get; set; }
        public Confirmedduringstay confirmedDuringStay { get; set; }
        public Confirmedaftercheckout confirmedAfterCheckOut { get; set; }
        public Unconfirmedfirstmessage unconfirmedFirstMessage { get; set; }
        public Unconfirmedsubsequentmessage unconfirmedSubsequentMessage { get; set; }
        public bool active { get; set; }
    }

    public class Confirmedbeforecheckin
    {
        public int delayInMinutes { get; set; }
    }

    public class Confirmeddayofcheckin
    {
        public int delayInMinutes { get; set; }
    }

    public class Confirmeddayofcheckout
    {
        public int delayInMinutes { get; set; }
    }

    public class Confirmedduringstay
    {
        public int delayInMinutes { get; set; }
    }

    public class Confirmedaftercheckout
    {
        public int delayInMinutes { get; set; }
    }

    public class Unconfirmedfirstmessage
    {
        public int delayInMinutes { get; set; }
    }

    public class Unconfirmedsubsequentmessage
    {
        public int delayInMinutes { get; set; }
    }

    public class Hooks
    {
        public object[] ignoredHooks { get; set; }
        public bool active { get; set; }
    }

    public class Calendarsmartrules
    {
        public object[] blockListings { get; set; }
        public bool active { get; set; }
    }

    public class Autoreviews
    {
        public string[] templates { get; set; }
        public bool active { get; set; }
        public int starRating { get; set; }
        public int daysBeforeSending { get; set; }
    }

    public class Autopricing
    {
        public Rule[] rules { get; set; }
        public bool active { get; set; }
    }

    public class Rule
    {
        public string _id { get; set; }
        public Condition condition { get; set; }
        public int startingFromDaysAhead { get; set; }
        public int tillDaysAhead { get; set; }
        public int amount { get; set; }
        public string unit { get; set; }
        public string subject { get; set; }
    }

    public class Condition
    {
        public int amount { get; set; }
    }

    public class Homeautomation
    {
        public Buzzer buzzer { get; set; }
    }

    public class Buzzer
    {
        public bool active { get; set; }
    }

    public class Autolist
    {
        public bool active { get; set; }
    }

    public class Tasks
    {
        public object[] defaultTasks { get; set; }
    }

    public class Autopayments
    {
        public object[] policy { get; set; }
    }

    public class Cleaningstatus
    {
        public bool active { get; set; }
    }

    public class Markups
    {
    }

    public class Prices
    {
        public float monthlyPriceFactor { get; set; }
        public float weeklyPriceFactor { get; set; }
        public int basePrice { get; set; }
        public string currency { get; set; }
        public int guestsIncludedInRegularFee { get; set; }
        public int extraPersonFee { get; set; }
        public int basePriceUSD { get; set; }
        public int cleaningFee { get; set; }
    }

    public class Terms
    {
        public int minNights { get; set; }
        public int maxNights { get; set; }
        public string cancellation { get; set; }
    }

    public class Picture
    {
        public string thumbnail { get; set; }
        public string regular { get; set; }
        public string large { get; set; }
        public string caption { get; set; }
    }

    public class Address
    {
        public string zipcode { get; set; }
        public string country { get; set; }
        public string city { get; set; }
        public string street { get; set; }
        public float lat { get; set; }
        public float lng { get; set; }
        public string full { get; set; }
        public string neighborhood { get; set; }
        public string apt { get; set; }
        public string searchable { get; set; }
    }

    public class Saas
    {
        public bool autoRenew { get; set; }
    }

    public class Cleaningstatus1
    {
        public string value { get; set; }
        public DateTime updatedAt { get; set; }
    }

    public class Publicdescription
    {
        public Guestcontrols guestControls { get; set; }
        public string summary { get; set; }
        public string houseRules { get; set; }
    }

    public class Guestcontrols
    {
        public bool allowsChildren { get; set; }
        public bool allowsInfants { get; set; }
        public bool allowsPets { get; set; }
        public bool allowsSmoking { get; set; }
        public bool allowsEvents { get; set; }
    }

    public class Instantbookable
    {
        public bool enabled { get; set; }
        public string visibility { get; set; }
        public int leadTime { get; set; }
    }

    public class Channelslisted
    {
        public Airbnb airbnb { get; set; }
        public string _id { get; set; }
    }

    public class Airbnb
    {
        public bool isListed { get; set; }
    }

    public class Privatedescription
    {
        public Wifi wifi { get; set; }
    }

    public class Wifi
    {
        public string network { get; set; }
        public string password { get; set; }
    }

    public class Cleaning
    {
        public string instructions { get; set; }
    }

    public class Postbookingservice
    {
        public bool monitorReservations { get; set; }
        public bool manualWork { get; set; }
        public bool findServiceProvider { get; set; }
        public bool handleEmergencies { get; set; }
        public bool reservationTask { get; set; }
    }

    public class Occupancystat
    {
        public string month { get; set; }
        public int available { get; set; }
        public int unavailable { get; set; }
        public int booked { get; set; }
        public int? rate { get; set; }
        public string _id { get; set; }
    }

    public class Customfield
    {
        public string _id { get; set; }
        public string fieldId { get; set; }
        public string value { get; set; }
    }

    public class Picture1
    {
        public string original { get; set; }
        public string thumbnail { get; set; }
        public string _id { get; set; }
        public string regular { get; set; }
        public string large { get; set; }
        public int id { get; set; }
        public int sort { get; set; }
        public string caption { get; set; }
    }

    public class Listingroom
    {
        public int id { get; set; }
        public int roomNumber { get; set; }
        public string _id { get; set; }
        public Bed[] beds { get; set; }
    }

    public class Bed
    {
        public int quantity { get; set; }
        public string type { get; set; }
        public string _id { get; set; }
    }

    public class Pendingtask
    {
        public string _id { get; set; }
        public string description { get; set; }
        public string platform { get; set; }
        public string mqId { get; set; }
        public DateTime createdAt { get; set; }
        public string error { get; set; }
    }

    public class Integration
    {
        public Airbnb2 airbnb2 { get; set; }
        public Bookingcom bookingCom { get; set; }
        public string _id { get; set; }
        public string platform { get; set; }
        public Rentalsunited rentalsUnited { get; set; }
        public string externalUrl { get; set; }
        public Airbnb1 airbnb { get; set; }
        public Agoda agoda { get; set; }
    }

    public class Airbnb2
    {
        public object[] daysOfWeekCheckIn { get; set; }
        public object[] daysOfWeekMinimumNights { get; set; }
    }

    public class Bookingcom
    {
        public object[] acceptedCreditCards { get; set; }
        public string[] errors { get; set; }
        public object[] taxInfo { get; set; }
        public DateTime connectedAt { get; set; }
        public bool isPublishedByGuesty { get; set; }
        public string status { get; set; }
        public string currency { get; set; }
        public int rateId { get; set; }
        public int hotelId { get; set; }
        public int id { get; set; }
    }

    public class Rentalsunited
    {
        public string currency { get; set; }
        public int id { get; set; }
        public string locationId { get; set; }
        public Financials financials { get; set; }
    }

    public class Financials
    {
        public Guestsincludedinregularfee guestsIncludedInRegularFee { get; set; }
        public string _id { get; set; }
    }

    public class Guestsincludedinregularfee
    {
        public string channelSyncStatus { get; set; }
    }

    public class Airbnb1
    {
        public int reviewsCount { get; set; }
        public int id { get; set; }
        public bool isCalendarSynced { get; set; }
        public float starRating { get; set; }
        public Financials1 financials { get; set; }
    }

    public class Financials1
    {
        public Guestsincludedinregularfee1 guestsIncludedInRegularFee { get; set; }
        public Baseprice basePrice { get; set; }
        public string _id { get; set; }
    }

    public class Guestsincludedinregularfee1
    {
        public string channelSyncStatus { get; set; }
    }

    public class Baseprice
    {
        public string channelSyncStatus { get; set; }
    }

    public class Agoda
    {
        public string id { get; set; }
        public string status { get; set; }
        public string currency { get; set; }
        public string roomId { get; set; }
        public string rateplanId { get; set; }
    }

}
