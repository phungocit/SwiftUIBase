# SwiftUIBase

An API service using Alamofire for SwiftUI and some common Views

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Installation

### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a tool for automating the distribution of Swift code and is integrated into the `swift` compiler.

Once you have your Swift package set up, adding SwiftUIBase as a dependency is as easy as adding it to the `dependencies` value of your `Package.swift` or the Package list in Xcode.

```swift
dependencies: [
    .package(url: "https://github.com/phungocit/SwiftUIBase.git", from: "1.0.0")
],
targets: [
    .target(name: "YourTarget", dependencies: ["SwiftUIBase"]),
]
```

### Usage

1. Create APIService

```swift
final class APIService: APIServiceBase {
    static var shared = APIService()
}
```

2. Create RepoModel

```swift
struct RepoModel: Codable {
    let id: Int?
    let name: String?
    let fullname: String?
    let urlString: String?
    let starCount: Int?
    let folkCount: Int?
    let owner: OwnerModel?
}

extension RepoModel {
    struct OwnerModel: Codable {
        let avatarUrl: String?

        private enum CodingKeys: String, CodingKey {
            case avatarUrl = "avatar_url"
        }
    }

    private enum CodingKeys: String, CodingKey {
        case id, name
        case fullname = "full_name"
        case urlString = "html_url"
        case starCount = "stargazers_count"
        case folkCount = "forks"
        case owner
    }
}

```

3. Create extension to get the API repos

```swift
// MARK: - GetRepos
extension APIService {
    func getRepos(_ input: GetReposInput) -> Observable<GetReposOutput> {
        request(input)
    }
}

// MARK: - Repos Input
extension APIService {
    struct ReposParameters: Encodable {
        let query: String
        let perPage: Int
        let page: Int

        private enum CodingKeys: String, CodingKey {
            case query = "q"
            case perPage
            case page
        }
    }

    final class GetReposInput: APIInput<ReposParameters> {
        init(getPageModel: GetPageModel) {
            super.init(
                urlString: APIService.Urls.getRepos,
                method: .get,
                parameters: ReposParameters(
                    query: "language:swift",
                    perPage: getPageModel.perPage,
                    page: getPageModel.page
                )
            )

            keyStrategyForDecodeResponse = .useDefaultKeys
        }
    }
}

// MARK: - Repos Output
extension APIService {
    struct GetReposOutput: Codable {
        let repos: [RepoModel]?
        let totalCount: Int?

        private enum CodingKeys: String, CodingKey {
            case totalCount
            case repos = "items"
        }
    }
}
```

4. Create ViewModel to call the APIService

```swift
final class ReposViewModel: ObservableObject {
    @Published var repos = [RepoModel]()
    @Published var isShowLoading = false

    private var disposables = Set<AnyCancellable>()

    init() {
        isShowLoading = true
        getRepos()
    }

    func getRepos() {
        APIService.shared.getRepos(
            APIService.GetReposInput(getPageModel: GetPageModel(page: 1, perPage: 30))
        )
        .receive(on: DispatchQueue.main)
        .sink { [unowned self] _ in
            self.isShowLoading = false
        } receiveValue: { [unowned self] repoReturned in
            self.repos = repoReturned.repos ?? []
        }
        .store(in: &disposables)
    }
}
```

5. Create View to receive results from ViewModel

```swift
struct ReposView: View {
    @StateObject private var viewModel = ReposViewModel()

    var body: some View {
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(viewModel.repos, id: \.id) { repo in
                    repoItem(repo: repo)
                }
            }
            .padding()
        }
        .loadingView(isShowing: $viewModel.isShowLoading)
        .navigationTitle("Repos")
    }

    func repoItem(repo: RepoModel) -> some View {
        HStack(spacing: 12) {
            if let url = URL(string: repo.owner?.avatarUrl ?? "") {
                AsyncImage(url: url) { image in
                    image
                        .resizable()
                } placeholder: {
                    ProgressView()
                }
                .frame(width: 56, height: 56)
            }
            if let urlString = repo.urlString, let destination = URL(string: urlString) {
                Link(repo.name ?? "", destination: destination)
            }
            if let starCount = repo.starCount {
                Spacer()
                HStack(spacing: 2) {
                    Text("\(starCount)")
                        .font(.callout)
                    Image(systemName: "star.fill")
                        .font(.caption)
                }
            }
        }
    }
}
```

https://github.com/phungocit/SwiftUIBase/assets/54695740/17f99e70-c35d-40d2-bca8-2da7ba862388

## Contribution

If you find a bug or have a way to improve the library, create an Issue or propose a Pull Request. We welcome contributions from the community.

## License

SwiftUIBase is available under the MIT license. See the LICENSE file for more info.

## Links

- [Clean Architecture (RxSwift + UIKit)](https://github.com/tuan188/MGCleanArchitecture)
