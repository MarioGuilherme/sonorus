using Sonorus.PostAPI.Models;

namespace Sonorus.PostAPI.Repository.Interfaces;

public interface ICommentRepository {
    Task<List<Comment>> GetAll();
}