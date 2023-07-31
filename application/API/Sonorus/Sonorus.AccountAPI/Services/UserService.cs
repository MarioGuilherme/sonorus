using AutoMapper;
using Sonorus.AccountAPI.Configuration;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Exceptions;
using Sonorus.AccountAPI.Models;
using Sonorus.AccountAPI.Repository.Interfaces;
using Sonorus.AccountAPI.Services.Interfaces;

namespace Sonorus.AccountAPI.Services;

public class UserService : IUserService {
    private readonly IUserRepository _userRepository;
    private readonly IMapper _mapper;

    public UserService(IUserRepository userRepository, IMapper mapper) {
        this._userRepository = userRepository;
        this._mapper = mapper;
    }

    public async Task<UserDTO> Login(string email, string nickname, string password) {
        User? user = await this._userRepository.Login(email, nickname, password) ?? throw new SonorusAPIException("Usuário não encontrado", 404);

        UserDTO userMapped = this._mapper.Map<UserDTO>(user);
        userMapped.Token = TokenService.GenerateToken(user);
        return userMapped;
    }

    public async Task<UserDTO> Register(UserDTO user) {
        User userMapped = this._mapper.Map<User>(user);
        await this._userRepository.Register(userMapped);
        user.Token = TokenService.GenerateToken(userMapped);
        return user;
    }
}