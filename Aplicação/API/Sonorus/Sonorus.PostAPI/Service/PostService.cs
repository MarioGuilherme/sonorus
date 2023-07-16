using AutoMapper;
using Microsoft.Extensions.Hosting;
using Sonorus.PostAPI.DTO;
using Sonorus.PostAPI.Models;
using Sonorus.PostAPI.Repository.Interfaces;
using Sonorus.PostAPI.Service.Interfaces;

namespace Sonorus.PostAPI.Service;

public class PostService : IPostService {
    private readonly IPostRepository _postRepository;
    private readonly IMapper _mapper;

    public PostService(IPostRepository postService, IMapper mapper) {
        this._postRepository = postService;
        this._mapper = mapper;
    }

    public async Task<List<PostDTO>> GetAll() {
        List<Post> posts = await this._postRepository.GetAll();
        return this._mapper.Map<List<PostDTO>>(posts);
    }

    public async Task<PostDTO> GetById(long idPost) {
        Post post = await this._postRepository.GetById(idPost);
        return this._mapper.Map<PostDTO>(post);
    }

    public async Task<bool> PostExists(long idPost) => await this._postRepository.PostExists(idPost);

    public async Task<long> Create(PostDTO post) {
        Post postMapped = this._mapper.Map<Post>(post);
        long idPost = await this._postRepository.Create(postMapped) ?? 0;
        return idPost;
    }

    public async Task Delete(long idPost) {
        //if (!(await this._postRepository.PostExists(idPost)))
        //    return 
        await this._postRepository.Delete(idPost);
    }

    public async Task Update(long idPost, PostDTO postForm) {
        Post postMapped = this._mapper.Map<Post>(postForm);
        postMapped.IdPost = idPost;
        await this._postRepository.Update(postMapped);
    }
}