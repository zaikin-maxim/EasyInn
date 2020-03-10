using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EasyInn.WebAPI.DataAccess.Repositories
{

    public class GuestyReservations
    {
        public ResultReservations[] results { get; set; }
        public string title { get; set; }
        public int count { get; set; }
        public string fields { get; set; }
        public int limit { get; set; }
        public int skip { get; set; }
    }

    public class ResultReservations
    {
        public string _id { get; set; }
        public IntegrationReservations integration { get; set; }
        public string accountId { get; set; }
        public string confirmationCode { get; set; }
        public string guestId { get; set; }
        public string listingId { get; set; }
        public DateTime checkIn { get; set; }
        public DateTime checkOut { get; set; }
        public ListingReservations listing { get; set; }
        public GuestReservations guest { get; set; }
        public bool isFrozen { get; set; }
    }

    public class IntegrationReservations
    {
        public string _id { get; set; }
        public string platform { get; set; }
        public Limitations limitations { get; set; }
    }

    public class Limitations
    {
        public object[] availableStatuses { get; set; }
    }

    public class ListingReservations
    {
        public string _id { get; set; }
        public string title { get; set; }
    }

    public class GuestReservations
    {
        public string _id { get; set; }
        public string fullName { get; set; }
    }

}
