using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Configuration;

public class MappingConfig {
    public static MapperConfiguration RegisterMaps() => new(config => {
        config.CreateMap<Post, PostDTO>().ReverseMap();
        config.CreateMap<Comment, CommentDTO>().ReverseMap();
    });
}