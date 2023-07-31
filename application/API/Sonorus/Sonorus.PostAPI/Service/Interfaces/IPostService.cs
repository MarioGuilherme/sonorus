using Sonorus.PostAPI.DTO;

namespace Sonorus.PostAPI.Service.Interfaces;

public interface IPostService {
    Task<List<PostDTO>> GetAll();
    Task<PostDTO> GetPostById(long idPost);
    Task<long> Create(PostDTO post);
    Task Delete(long idPost);
    Task Update(PostDTO post);
}