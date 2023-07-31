using AutoMapper;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Configuration;

public class MappingConfig {
    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<User, UserDTO>().ReverseMap();
    });
}