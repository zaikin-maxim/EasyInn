using System;
using System.Data.Entity.SqlServer;
using System.Linq;
using BusinessFramework.WebAPI.Common.Data;
using BusinessFramework.WebAPI.Contracts.Files;
using EasyInn.Contracts;
using EasyInn.Contracts.Enums;
using EasyInn.WebAPI.Contracts;
using EasyInn.WebAPI.Contracts.Contexts;
using EasyInn.WebAPI.Contracts.DataObjects;
using EasyInn.WebAPI.Contracts.Repositories;

using System.IO;
using System.Net;
using System.Text;
using System.Collections.Generic;
using System.Text.Json;
using System.Text.Json.Serialization;


namespace EasyInn.WebAPI.DataAccess.Repositories
{
    /// <summary>
    /// Repository for <see cref="UserQueryRepository"/> objects
    /// </summary>
    public sealed class UserQueryRepository : CodeBehind.CodeBehindUserQueryRepository, IUserQueryRepository
    {
        private readonly IUserExtensionRepository _userExtensionRepository;
        private readonly ISysUserRepository _sysUserRepository;
        private readonly IListingRepository _listingRepository;

        /// <summary>
        /// Ctor
        /// </summary>
        public UserQueryRepository(
            //--  custom dependencies
            IUserExtensionRepository userExtensionRepository,
            ISysUserRepository sysUserRepository,
            IListingRepository listingRepository,
            //-- /custom dependencies
            IApiDbContext context, ISecurityService security, IServerContext serverContext)
            : base(context, security, serverContext)
        {
            this._userExtensionRepository = userExtensionRepository;
            this._sysUserRepository = sysUserRepository;
            this._listingRepository = listingRepository;
        }


        public override UserQuery Create(UserQuery entity)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="entity"></param>
        /// <returns></returns>
        /// <exception cref="NotImplementedException"></exception>
        public override UserQuery Update(UserQuery entity)
        {
            var isAdmin = Security.Authorize(DomainPermissions.UserManagement);
            var currentUserId = isAdmin ? entity.SysUser_Id : Security.CurrentUser.Id;
            var extension = _userExtensionRepository.Set().FirstOrDefault(x => x.UserId == currentUserId);
            // TODO check null
            var user = _sysUserRepository.GetByKey(currentUserId);


            if (isAdmin)
            {
                extension.GuestyKeyAPI = entity.GuestyKeyAPI;
                extension.GuestySecret = entity.GuestySecret;
                extension.NukiToken = entity.NukiToken;
                // TODO all fields for simple! user

                string resultGuesty;
                string resultNuki;

                #region ApiGuesty
                //string ApiToken = "b0c134f42c451881d65b9aae7bb2f4f1";
                //string ApiSecret = "07e9b89fa5010c6d5c8e1751e0694b6a";
                string ApiRequestGuesty(string hvost)
                {
                    string address = "https://api.guesty.com/api/v2/" + hvost;
                    string Storage = "C:\\EasyProject\\EasyInn\\JSON_data\\guesty_" + hvost + ".json";


                    HttpWebRequest webRequest = (HttpWebRequest)WebRequest.Create(address);
                    webRequest.KeepAlive = false;
                    webRequest.ProtocolVersion = HttpVersion.Version11;
                    webRequest.Timeout = 60000;
                    ServicePointManager.Expect100Continue = false;
                    ServicePointManager.SecurityProtocol = SecurityProtocolType.Tls12;
                    webRequest.Method = "GET";
                    webRequest.ContentType = "application/json";
                    webRequest.ContentLength = 0;
                    string autorization = extension.GuestyKeyAPI + ":" + extension.GuestySecret;
                    byte[] binaryAuthorization = Encoding.UTF8.GetBytes(autorization);
                    autorization = Convert.ToBase64String(binaryAuthorization);
                    autorization = "Basic " + autorization;
                    webRequest.Headers.Add("Authorization", autorization);
                    var response = (HttpWebResponse)webRequest.GetResponse();
                    //if (response.StatusCode != HttpStatusCode.OK) Console.WriteLine("{0}", response.Headers);

                    StreamReader reader = new StreamReader(response.GetResponseStream());
                    using (StreamWriter writer = new StreamWriter(Storage))
                    {
                        string s = reader.ReadToEnd();
                        writer.WriteLine(s);
                        reader.Close();
                        writer.Close();
                    }

                    string jsonString = File.ReadAllText(Storage);
                    return jsonString;
                }
                #endregion

                #region ApiNuki
                string ApiRequestNuki(string hvost, string nameStorage)
                {
                    string address = "https://api.nuki.io/" + hvost;
                    string Storage = "C:\\EasyProject\\EasyInn\\JSON_data\\" + nameStorage + ".json";

                    //var key = "4058abe4849164e2cece7614ad785d2c931a3b118c7213d45da21294e4abd4e4ba551f0b4cf2f367";
                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(address);


                    request.ContentType = "application/json";
                    request.Headers["Authorization"] = "Bearer " + extension.NukiToken;
                    request.Method = "GET";

                    HttpWebResponse response = request.GetResponse() as HttpWebResponse;
                    StreamReader reader = new StreamReader(response.GetResponseStream());
                    using (StreamWriter writer = new StreamWriter(Storage))
                    {
                        string s = reader.ReadToEnd();
                        writer.WriteLine(s);
                        reader.Close();
                        writer.Close();
                    }

                    string jsonString = File.ReadAllText(Storage);
                    return jsonString;
                }
                #endregion

                #region CreateUserNuki

                void CreatUserNuki(string name, string email) {

                    string address = "https://api.nuki.io/account/user";

                    //var key = "4058abe4849164e2cece7614ad785d2c931a3b118c7213d45da21294e4abd4e4ba551f0b4cf2f367";
                    HttpWebRequest request = (HttpWebRequest)WebRequest.Create(address);


                    request.ContentType = "application/json";
                    request.Headers["Authorization"] = "Bearer " + extension.NukiToken;
                    request.Method = "PUT";

                    string data = "{\"email\":\"" + email + "\",\"name\":\"" + name + "\"}";
                    byte[] byteArray = Encoding.UTF8.GetBytes(data);
                    request.ContentLength = byteArray.Length;

                    using (Stream dataStrem = request.GetRequestStream())
                    {
                        dataStrem.Write(byteArray, 0, byteArray.Length);
                    }

                    string testKey = ApiRequestNuki("account/user", "accounts");
                    List<NukiAccount> Account = JsonSerializer.Deserialize<List<NukiAccount>>(testKey);

                    var userAccount = Account.FirstOrDefault(x => string.Compare(email, x.email) == 0 && string.Compare(name, x.name) == 0);

                    string createKeyUrl = "https://api.nuki.io/smartlock/331542457/auth";

                    HttpWebRequest request1 = (HttpWebRequest)WebRequest.Create(createKeyUrl);


                    request1.ContentType = "application/json";
                    request1.Headers["Authorization"] = "Bearer " + extension.NukiToken;
                    request1.Method = "PUT";

                    string data1 = "{\"accountUserId\":\"" + userAccount.accountUserId + "\",\"name\": \"testKey\", \"remoteAllowed\": false,\"smartActionsEnabled\": false,\"allowedUntilDate\": \"2020-02-14T15:16:44.023Z\"}";
                    byte[] byteArray1 = Encoding.UTF8.GetBytes(data1);
                    request1.ContentLength = byteArray1.Length;

                    using (Stream dataStrem = request1.GetRequestStream())
                    {
                        dataStrem.Write(byteArray1, 0, byteArray1.Length);
                    }
                }

                #endregion
                resultGuesty = ApiRequestGuesty("listings");
                resultNuki = ApiRequestNuki("smartlock","smartlock");

                CreatUserNuki("test_key", "incold0310.copy@yandex.ru");

                GuestyListings Listings = JsonSerializer.Deserialize<GuestyListings>(resultGuesty);
                List<NukiSmartlock> Smartlocks = JsonSerializer.Deserialize<List<NukiSmartlock>>(resultNuki);

                // TODO Select exisitng listing
                int item_authId = 0;                                    
                var userListing = _listingRepository.Set().Where(x => x.UserId == 1).ToList();
                var JSON_idList = new List<string>() { };

                foreach (var listings_item in Listings.results)
                {  

                    foreach(var field in listings_item.customFields)
                    {
                        item_authId = Smartlocks.Where(x => string.Compare(field.value, x.name) == 0).Select(s => s.authId).FirstOrDefault();
                    }

                    JSON_idList.Add(listings_item._id);

                    var checkExist = userListing.FirstOrDefault(x => x.PMSApartementId == listings_item._id);

                        checkExist.Address = listings_item.address.full;
                        checkExist.UserId = 1;
                        checkExist.ApartmentName = listings_item.title;
                        checkExist.City = listings_item.address.city;
                        checkExist.LockerIntercomCode = "12345678";
                        checkExist.LockerAPIKey = "98765";
                        checkExist.LockerSharedKey = "dfghoi0987";
                        checkExist.LockerAuthId = item_authId;
                        checkExist.PMSApartementId = listings_item._id;
                        checkExist.IsActive = listings_item.active;
                        checkExist.UpsellId = "esdfg";
                        checkExist.IsLock = true;
                        checkExist.ManagerName = "Test";

                    if (checkExist != null)
                    {
                        _listingRepository.Update(checkExist);
                        
                    }
                    else
                     {
                            _listingRepository.Create(checkExist);
                    };
                    item_authId = 0;
                }
               
                foreach(var elem in userListing)
                {
                    if (JSON_idList.IndexOf(elem.PMSApartementId) == -1)
                    {
                       _listingRepository.Delete(elem);
                    }
                }
                _userExtensionRepository.Update(extension);

            }
            else
            { // simple user
                #region Change Password

                if (!string.IsNullOrWhiteSpace(entity.Password))
                {
                    user.Password = entity.Password;

                    _sysUserRepository.Update(user);
                }
                #endregion

                // TODO all fields for simple! user

                _userExtensionRepository.Update(extension);

            }

            return entity;
        }

        /// <summary>
        /// 
        /// </summary>
        /// <param name="key"></param>
        /// <exception cref="NotImplementedException"></exception>
        public override void Delete(int key)
        {
            throw new NotImplementedException();
        }
    }
}

