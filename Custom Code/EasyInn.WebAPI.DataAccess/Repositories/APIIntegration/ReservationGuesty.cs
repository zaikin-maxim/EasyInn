using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EasyInn.WebAPI.DataAccess.Repositories
{

    public class ReservationGuesty
    {
        public ResultReserv[] results { get; set; }
        public string title { get; set; }
        public int count { get; set; }
        public string fields { get; set; }
        public int limit { get; set; }
        public int skip { get; set; }
    }

    public class ResultReserv
    {
        public string _id { get; set; }
        public IntegrationReserv integration { get; set; }
        public string accountId { get; set; }
        public string listingId { get; set; }
        public string confirmationCode { get; set; }
        public string guestId { get; set; }
        public DateTime checkIn { get; set; }
        public DateTime checkOut { get; set; }
        public GuestReserv guest { get; set; }
        public ListingReserv listing { get; set; }
        public bool isFrozen { get; set; }
    }

    public class IntegrationReserv
    {
        public string _id { get; set; }
        public string platform { get; set; }
        public Limitations limitations { get; set; }
    }

    public class Limitations
    {
        public object[] availableStatuses { get; set; }
    }

    public class GuestReserv
    {
        public string _id { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string phone { get; set; }
        public string email { get; set; }
    }

    public class ListingReserv
    {
        public string _id { get; set; }
    }


}
