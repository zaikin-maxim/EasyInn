using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EasyInn.WebAPI.DataAccess.Repositories
{
    public struct AllReservations
    {
        public DateTime CheckInDate, CheckOutDate;
        public int ListingId;
        public string PMSReservationId, GuestId;

        public AllReservations(string PMSReservationId_, string GuestId_, int ListingId_, DateTime CheckInDate_, DateTime CheckOutDate_)
        {
            PMSReservationId = PMSReservationId_;
            GuestId = GuestId_;
            ListingId = ListingId_;
            CheckInDate = CheckInDate_;
            CheckOutDate = CheckOutDate_;
        }
    }
}
