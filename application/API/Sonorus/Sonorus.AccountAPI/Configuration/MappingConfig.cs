using AutoMapper;
using Sonorus.AccountAPI.DTO;
using Sonorus.AccountAPI.Models;

namespace Sonorus.AccountAPI.Configuration;

public class MappingConfig {
    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<User, UserRegisterDTO>().ReverseMap();
        config.CreateMap<User, UserLoginDTO>().ReverseMap();
        config.CreateMap<Interest, InterestDTO>().ReverseMap();
        //config.CreateMap<UserInterest, UserInterestsDTO>().ReverseMap();
    });
}