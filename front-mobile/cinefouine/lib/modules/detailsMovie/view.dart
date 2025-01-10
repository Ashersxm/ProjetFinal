import 'package:auto_route/auto_route.dart';
import 'package:cinefouine/core/widgets/mainAppBar.dart';
import 'package:cinefouine/data/entities/movie/movie_info.dart';
import 'package:cinefouine/data/entities/movie/movie_info_detail.dart';
import 'package:cinefouine/data/repositories/movie_repository.dart';
import 'package:cinefouine/router/app_router.dart';
import 'package:cinefouine/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:cinefouine/core/widgets/cineFouineBoutton.dart';
import 'package:cinefouine/core/widgets/cineFouineHugeBoutton.dart';

part 'view.g.dart';

@Riverpod(keepAlive: true)
class MovieSeleted extends _$MovieSeleted {
  @override
  FutureOr<MovieInfoDetail?> build() async {
    AsyncValue.loading();
    return null;
  }

  Future<bool> setMovie(MovieInfo? value) async {
    AsyncValue.loading();
    final repoMovie = ref.read(movieRepositoryProvider);
    if (value != null) {
      state = AsyncValue.data(await repoMovie.getMovieDetails(value.id));
    } else {
      state = AsyncValue.data(null);
    }
    return true;
  }
}

@RoutePage()
class DetailsMovieView extends ConsumerWidget {
  const DetailsMovieView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final movieSelected = ref.watch(movieSeletedProvider);
    final router = ref.watch(appRouterProvider);

    return Scaffold(
      appBar: MainAppBar(
        title: "Details Film",
        isBackNavigationAvailable: router.canNavigateBack,
        onBackButtonPressed: () {
          ref.read(movieSeletedProvider.notifier).setMovie(null);
          router.maybePop();
        },
      ),
      backgroundColor: AppColors.secondary,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: movieSelected.when(
          data: (data) {
            if (data == null) {
              return const Center(child: CircularProgressIndicator());
            }
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildMovieHeader(data),
                const SizedBox(height: 16),
                Text(
                  data.details?.overview ?? "Aucune description disponible.",
                  style: const TextStyle(
                    color: AppColors.white,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 16),
                _buildActorsSection(data),
                const SizedBox(height: 16),
                CineFouineHugeBoutton(onPressed: () {}, text: "Quiz"),
                const SizedBox(height: 16),
                _buildRatingSection(),
                const SizedBox(height: 16),
                _buildCommentsSection(),
              ],
            );
          },
          error: (error, stackTrace) {
            return Center(
              child: Text(
                'Erreur: $error',
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
            );
          },
          loading: () {
            return const Center(child: CircularProgressIndicator());
          },
        ),
      ),
    );
  }

  Widget _buildMovieHeader(MovieInfoDetail movie) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (movie.details?.posterPath != null)
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: Image.network(
              'https://image.tmdb.org/t/p/w500${movie.details?.posterPath}',
              width: 100,
              height: 150,
              fit: BoxFit.cover,
            ),
          ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                movie.details?.title ?? "Unkown",
                style: const TextStyle(
                  color: AppColors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Année: ${movie.details?.releaseDate?.year ?? "Inconnue"}",
                style: const TextStyle(color: AppColors.white, fontSize: 14),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Cinefouineboutton(onPressed: () {}, text: "Regarder"),
                  const SizedBox(width: 8),
                  Container(
                    width: 40, // Taille du cercle
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary, // Contour bleu
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.thumb_up, color: AppColors.white),
                      onPressed: () {},
                      iconSize: 20, // Taille du pouce
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 40, // Taille du cercle
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.red, // Contour rouge
                        width: 2,
                      ),
                    ),
                    child: IconButton(
                      icon:
                          const Icon(Icons.thumb_down, color: AppColors.white),
                      onPressed: () {},
                      iconSize: 20, // Taille du pouce
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActorsSection(MovieInfoDetail movie) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Actors",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal, // Permet le défilement horizontal
          child: Row(
            children: List.generate(
              movie.actors?.length ?? 0,
              (index) {
                final actor = movie.actors?[index];
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: Column(
                    children: [
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          actor?.profilePath != null
                              ? "https://image.tmdb.org/t/p/w500${actor?.profilePath}"
                              : "https://via.placeholder.com/80", // Image par défaut si `profilePath` est null
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        actor?.name ??
                            "Unknown", // Affiche "Unknown" si `name` est null
                        style: const TextStyle(
                          color: AppColors.white,
                          fontSize: 12,
                          overflow:
                              TextOverflow.ellipsis, // Gestion du débordement
                        ),
                        maxLines: 1,
                      ),
                      Text(
                        actor?.character ?? "", // Affiche le personnage
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 10,
                          overflow: TextOverflow.ellipsis,
                        ),
                        maxLines: 1,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildRatingSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Note",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: List.generate(
            5,
            (index) => const Icon(
              Icons.star,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCommentsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          "Commentaire",
          style: TextStyle(
            color: AppColors.white,
            fontSize: 16,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          decoration: InputDecoration(
            hintText: "Écrire un commentaire ...",
            hintStyle: const TextStyle(color: AppColors.white),
            filled: true,
            fillColor: AppColors.primary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide.none,
            ),
          ),
        ),
        const SizedBox(height: 16),
        _buildCommentItem(
          avatarUrl: "https://via.placeholder.com/40",
          comment:
              "Je suis devenu une personne différente depuis que j'ai vu cette masterclass",
        ),
      ],
    );
  }

  Widget _buildCommentItem(
      {required String avatarUrl, required String comment}) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CircleAvatar(
          backgroundImage: NetworkImage(avatarUrl),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              comment,
              style: const TextStyle(color: AppColors.white, fontSize: 14),
            ),
          ),
        ),
      ],
    );
  }
}
