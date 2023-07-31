using Sonorus.PostAPI.DTO;

namespace Sonorus.PostAPI.Service.Interfaces;

public interface ICommentService {
    Task<List<CommentDTO>> GetAll();
}