using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace EasyInn.WebAPI.DataAccess.Repositories
{

    public class Guests
    {
        public Result11[] results { get; set; }
        public int count { get; set; }
        public string fields { get; set; }
        public int limit { get; set; }
        public int skip { get; set; }
    }

    public class Result11
    {
        public string _id { get; set; }
        public Airbnb11 airbnb { get; set; }
        public Airbnb22 airbnb2 { get; set; }
        public Policy policy { get; set; }
        public string[] verifications { get; set; }
        public string[] emails { get; set; }
        public string[] phones { get; set; }
        public string[] communicationMethods { get; set; }
        public object[] paymentMethodIds { get; set; }
        public string accountId { get; set; }
        public Bookingcom bookingCom { get; set; }
        public string hometown { get; set; }
        public Picture12[] pictures { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string fullName { get; set; }
        public string phone { get; set; }
        public string email { get; set; }
        public int __v { get; set; }
        public bool confirmed { get; set; }
        public bool hasVerifiedId { get; set; }
        public string languages { get; set; }
        public Picture11 picture { get; set; }
    }

    public class Airbnb11
    {
        public long id { get; set; }
        public string url { get; set; }
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string fullName { get; set; }
    }

    public class Airbnb22
    {
        public long id { get; set; }
        public string index { get; set; }
    }

    public class Policy
    {
        public Marketing marketing { get; set; }
        public Privacy privacy { get; set; }
    }

    public class Marketing
    {
        public bool isAccepted { get; set; }
        public DateTime? dateOfAcceptance { get; set; }
    }

    public class Privacy
    {
        public DateTime dateOfAcceptance { get; set; }
        public int version { get; set; }
        public bool isAccepted { get; set; }
    }

    public class Bookingcom11
    {
        public string firstName { get; set; }
        public string lastName { get; set; }
        public string fullName { get; set; }
    }

    public class Picture11
    {
        public string _id { get; set; }
        public string thumbnail { get; set; }
        public string large { get; set; }
        public string regular { get; set; }
    }

    public class Picture12
    {
        public string _id { get; set; }
        public string thumbnail { get; set; }
        public string large { get; set; }
        public string regular { get; set; }
    }

}
