using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface IPostRepository {
    Task<List<Post>> GetAll();
    Task<Post?> GetById(long idPost);
    Task<bool> PostExists(long idPost);
    Task<long?> Create(Post post);
    Task Delete(long idPost);
    Task Update(Post postForm);
}