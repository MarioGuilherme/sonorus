using AutoMapper;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Exceptions;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Service;

public class PostService : IPostService {
    private readonly IPostRepository _postRepository;
    private readonly IMapper _mapper;

    public PostService(IPostRepository postRepository, IMapper mapper) {
        this._postRepository = postRepository;
        this._mapper = mapper;
    }

    public async Task<List<PostDTO>> GetAll() {
        List<Post> posts = await this._postRepository.GetAll();
        return this._mapper.Map<List<PostDTO>>(posts);
    }

    public async Task<PostDTO> GetPostById(long idPost) {
        Post? post = await this._postRepository.GetById(idPost);

        return post is null
            ? throw new SonorusAPIException("Publicação não encontrada", 404)
            : this._mapper.Map<PostDTO>(post);
    }

    public async Task<long> Create(PostDTO post) {
        Post postMapped = this._mapper.Map<Post>(post);

        long? idPost = await this._postRepository.Create(postMapped);

        return idPost is null
            ? throw new SonorusAPIException("Falha ao criar a publicação", 400)
            : (long) idPost;
    }

    public async Task Delete(long idPost) {
        bool postExists = await this._postRepository.PostExists(idPost);

        if (!postExists)
            throw new SonorusAPIException("Publicação não encontrada", 404);

        await this._postRepository.Delete(idPost);
    }

    public async Task Update(PostDTO post) {
        bool postExists = await this._postRepository.PostExists(post.IdPost);

        if (!postExists)
            throw new SonorusAPIException("Publicação não encontrada", 404);

        Post postMapped = this._mapper.Map<Post>(post);
        await this._postRepository.Update(postMapped);
    }
}