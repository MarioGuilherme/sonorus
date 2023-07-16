using Sonorus.PostAPI.DTO;

namespace Sonorus.PostAPI.Service.Interfaces;

public interface IPostService {
    Task<List<PostDTO>> GetAll();
    Task<PostDTO> GetById(long idPost);
    Task<bool> PostExists(long idPost);
    Task<long> Create(PostDTO post);
    Task Delete(long idPost);
    Task Update(long idPost, PostDTO postForm);
}