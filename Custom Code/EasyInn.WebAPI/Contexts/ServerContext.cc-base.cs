using System;
using BusinessFramework.WebAPI.Contracts.Files;
using EasyInn.WebAPI.Contracts.Contexts;


namespace EasyInn.WebAPI.Contexts
{
    /// <summary>
    /// 
    /// </summary>
    public class ServerContext : IServerContext
    {    
        /// <summary>
        /// 
        /// </summary>
		public int CurrentUserId
		{
            get { throw new NotImplementedException(); }
        }
    }
}