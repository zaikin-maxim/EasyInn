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


namespace EasyInn.WebAPI.DataAccess.Repositories
{
    /// <summary>
    /// Repository for <see cref="UserQueryRepository"/> objects
    /// </summary>
    public sealed class UserQueryRepository : CodeBehind.CodeBehindUserQueryRepository, IUserQueryRepository
    {
        private readonly IUserExtensionRepository _userExtensionRepository;
        private readonly ISysUserRepository _sysUserRepository;

        /// <summary>
        /// Ctor
        /// </summary>
        public UserQueryRepository(
            //--  custom dependencies
            IUserExtensionRepository userExtensionRepository,
            ISysUserRepository sysUserRepository,
            //-- /custom dependencies
            IApiDbContext context, ISecurityService security, IServerContext serverContext) 
		    : base(context, security, serverContext)
        {
            this._userExtensionRepository = userExtensionRepository;
            this._sysUserRepository = sysUserRepository;
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

            }
            else
            { // simple user

                #region Change Password

                if ( !string.IsNullOrWhiteSpace(entity.Password) )
                {
                    user.Password = entity.Password;

                    _sysUserRepository.Update(user);
                   
                }
                #endregion


                extension.GuestyKeyAPI = entity.GuestyKeyAPI;
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