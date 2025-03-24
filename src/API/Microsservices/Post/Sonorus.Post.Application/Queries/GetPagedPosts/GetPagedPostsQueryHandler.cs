using AutoMapper;
using MediatR;
using Sonorus.Post.Application.ViewModels;
using Sonorus.Post.Core.Entities;
using Sonorus.Post.Infrastructure.Persistence;
using System.Net.Http.Headers;
using System.Net.Http.Json;

namespace Sonorus.Post.Application.Queries.GetPagedPosts;

public class GetPagedPostsQueryHandler(IUnitOfWork unitOfWork, IHttpClientFactory httpClientFactory, IMapper mapper) : IRequestHandler<GetPagedPostsQuery, IEnumerable<PostViewModel>> {
    private readonly IUnitOfWork _unitOfWork = unitOfWork;
    private readonly IHttpClientFactory _httpClientFactory = httpClientFactory;
    private readonly IMapper _mapper = mapper;

    public async Task<IEnumerable<PostViewModel>> Handle(GetPagedPostsQuery request, CancellationToken cancellationToken) {
        using HttpClient userMShttpClient = this._httpClientFactory.CreateClient("API_GATEWAY");
        userMShttpClient.DefaultRequestHeaders.Authorization = new AuthenticationHeaderValue("Bearer", request.AccessToken);

        if (!request.ContentByPreference) {
            List<Core.Entities.Post> posts = await this._unitOfWork.Posts.GetPagedPostsAsync(request.Offset, request.Limit);

            if (posts.Count == 0) return [];

            List<PostViewModel> mappedPosts = [];
            IEnumerable<long> userIds = posts.Select(post => post.UserId).Distinct();
            userMShttpClient.DefaultRequestHeaders.Clear();

            Task<List<UserViewModel>?> authors = userMShttpClient.GetFromJsonAsync<List<UserViewModel>>(
                $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
                cancellationToken: cancellationToken
            );
            Task<List<InterestViewModel>?> allInterests = userMShttpClient.GetFromJsonAsync<List<InterestViewModel>>("interests", cancellationToken: cancellationToken);

            await Task.WhenAll([authors, allInterests]);

            foreach (Core.Entities.Post post in posts) {
                UserViewModel? author = authors.Result!.FirstOrDefault(user => user.UserId == post.UserId);
                if (author is null) continue;
                PostViewModel postViewModel = new(
                    post.PostId,
                    post.Content,
                    post.PostedAt,
                    post.PostLikers.Count,
                    post.Comments.Count,
                    post.Tablature,
                    post.Medias.Select(this._mapper.Map<MediaViewModel>)
                ) {
                    Author = author,
                    IsLikedByMe = post.PostLikers.Any(post => post.UserId == request.UserId)
                };

                foreach (PostInterest postInterest in post.PostInterests) {
                    InterestViewModel interestViewModel = allInterests.Result!.First(interest => interest.InterestId == postInterest.InterestId);
                    postViewModel.Interests.Add(interestViewModel);
                }

                mappedPosts.Add(postViewModel);
            }

            return mappedPosts;
        } else {
            List<InterestViewModel>? myInterests = await userMShttpClient.GetFromJsonAsync<List<InterestViewModel>>("users/me/interests", cancellationToken: cancellationToken);
            List<Core.Entities.Post> posts = await this._unitOfWork.Posts.GetPagedPostsAsync(request.Offset, request.Limit, myInterests!.Select(interest => interest.InterestId));

            if (posts.Count == 0) return [];

            List<PostViewModel> mappedPosts = [];
            IEnumerable<long> userIds = posts.Select(post => post.UserId).Distinct();
            userMShttpClient.DefaultRequestHeaders.Clear();

            Task<List<UserViewModel>?> authors = userMShttpClient.GetFromJsonAsync<List<UserViewModel>>(
                $"users?{string.Join('&', userIds.Select(userId => $"id={userId}"))}",
                cancellationToken: cancellationToken
            );
            Task<List<InterestViewModel>?> allInterests = userMShttpClient.GetFromJsonAsync<List<InterestViewModel>>("interests", cancellationToken: cancellationToken);

            await Task.WhenAll([authors, allInterests]);

            foreach (Core.Entities.Post post in posts) {
                UserViewModel? author = authors.Result!.FirstOrDefault(user => user.UserId == post.UserId);
                if (author is null) continue;
                PostViewModel postViewModel = new(
                    post.PostId,
                    post.Content,
                    post.PostedAt,
                    post.PostLikers.Count,
                    post.Comments.Count,
                    post.Tablature,
                    this._mapper.Map<IEnumerable<MediaViewModel>>(post.Medias)
                ) {
                    Author = author,
                    IsLikedByMe = post.PostLikers.Any(post => post.UserId == request.UserId)
                };

                foreach (PostInterest postInterest in post.PostInterests) {
                    InterestViewModel interestViewModel = allInterests.Result!.First(interest => interest.InterestId == postInterest.InterestId);
                    postViewModel.Interests.Add(interestViewModel);
                }

                mappedPosts.Add(postViewModel);
            }

            return mappedPosts;
        }
    }
}