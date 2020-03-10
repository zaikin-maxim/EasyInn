using System;


namespace EasyInn.WebAPI.DataAccess.Repositories
{

    public class NukiAccount
    {
        public int accountUserId { get; set; }
        public int accountId { get; set; }
        public string email { get; set; }
        public string name { get; set; }
        public string language { get; set; }
        public DateTime creationDate { get; set; }
        public DateTime updateDate { get; set; }
    }

}
