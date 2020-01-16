using System;
using BusinessFramework.WebAPI.Contracts.Files;
using EasyInn.WebAPI.Contracts;
using EasyInn.WebAPI.Contracts.Contexts;
using EasyInn.WebAPI.Contracts.Repositories;


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
    }
}