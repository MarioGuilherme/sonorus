using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Service;

public class CommentService : ICommentService {
    private readonly ICommentRepository _commentRepository;
    private readonly IMapper _mapper;

    public CommentService(ICommentRepository commentRepository, IMapper mapper) {
        this._commentRepository = commentRepository;
        this._mapper = mapper;
    }

    public async Task<List<CommentDTO>> GetAll() {
        List<Comment> comments = await this._commentRepository.GetAll();
        return this._mapper.Map<List<CommentDTO>>(comments);
    }
}