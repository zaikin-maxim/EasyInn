using System;
using BusinessFramework.WebAPI.Contracts.Files;
using EasyInn.WebAPI.Contracts;
using EasyInn.WebAPI.Contracts.Contexts;
using EasyInn.WebAPI.Contracts.Repositories;
using System.Net.Http.Headers;
using System.Net;
using System.Web;
using System.Text;

namespace EasyInn.WebAPI.Contexts
{
    /// <summary>
    /// 
    /// </summary>
    public class ServerContext : IServerContext
    {
        private readonly ISecurityService _securityService;
        private readonly IUserExtensionRepository _userExtensionRepository;


        public ServerContext(ISecurityService securityService,
            IUserExtensionRepository userExtensionRepository
        )
        {
            _securityService = securityService;
            _userExtensionRepository = userExtensionRepository;
        }


        /// <summary>
        /// 
        /// </summary>
		public int CurrentUserId
        {
            get { return _securityService.CurrentUser.Id; }
        }

        public string CurrentRegCode
        {

            get {
                //HttpContext httpContext = HttpContext.Current;
                //    string authHeader = httpContext.Request.Headers["Authorization"];
                //    if (authHeader != null && authHeader.StartsWith("Basic"))
                //    {
                //        string encodedUsernamePassword = authHeader.Substring("Basic ".Length).Trim();
                //        Encoding encoding = Encoding.GetEncoding("iso-8859-1");
                //        string usernamePassword = encoding.GetString(Convert.FromBase64String(encodedUsernamePassword));

                //        int separatorIndex = usernamePassword.IndexOf(':');

                //        //var username = usernamePassword.Substring(0, separatorIndex);
                //        var password = usernamePassword.Substring(separatorIndex + 1);
                //        return password;

                //    }
                return "No";
            }
        }
    }
}