import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pokedex/components/badge.dart';
import 'package:pokedex/controllers/search/search_page_controller.dart';
import 'package:pokedex/helper/cached_pallete.dart';
import 'package:pokedex/helper/helper.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final _searchController = Get.put(SearchPageController());
  final _controller = ScrollController();

  void init() async {
    EasyLoading.show(dismissOnTap: false, status: 'Load...');
    await _searchController.init();
    EasyLoading.dismiss();
  }

  @override
  void initState() {
    super.initState();

    init();

    _controller.addListener(() async {
      if (_controller.offset >= _controller.position.maxScrollExtent &&
          !_controller.position.outOfRange &&
          _searchController.isCanLoadMore()) {
        EasyLoading.show(dismissOnTap: false, status: 'Load...');
        await _searchController.loadMore();
        EasyLoading.dismiss();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Positioned(
              right: -160,
              top: -160,
              child: SvgPicture.asset(
                'assets/pokemon_icon.svg',
                colorFilter: ColorFilter.mode(
                  Colors.grey.shade200,
                  BlendMode.srcIn,
                ),
                width: 400,
              ),
            ),
            Obx(
              () {
                return Padding(
                  padding: const EdgeInsets.only(left: 8, right: 8, top: 24),
                  child: RefreshIndicator(
                    onRefresh: () => _searchController.init(),
                    child: CustomScrollView(
                      physics: const BouncingScrollPhysics(),
                      controller: _controller,
                      slivers: [
                        const SliverPadding(
                          padding: EdgeInsets.only(bottom: 24),
                          sliver: SliverToBoxAdapter(
                            child: Text(
                              'Pokedex',
                              style: TextStyle(
                                fontSize: 42,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ),
                        ),
                        SliverGrid.builder(
                          itemCount: _searchController.pokemons.length,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            childAspectRatio: 1.2,
                          ),
                          itemBuilder: (context, i) {
                            final item = _searchController.pokemons[i];
                            final imageUrl = item.imageUrl;
                            final types = item.types;

                            return _PokemonItem(
                              onTap: () async {
                                if (item.eggGroup == null ||
                                    item.gender == null) {
                                  EasyLoading.show();
                                }

                                item.eggGroup ??= await _searchController
                                    .getEggGroup(item.id);
                                item.gender ??=
                                    await _searchController.getGender(item.id);

                                await EasyLoading.dismiss();
                                Get.toNamed('/detail', arguments: item);
                              },
                              imageUrl: imageUrl,
                              name: item.name,
                              types: types,
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            )
          ],
        ),
      ),
    );
  }
}

class _PokemonItem extends StatefulWidget {
  const _PokemonItem(
      {super.key,
      required this.imageUrl,
      required this.name,
      required this.types,
      required this.onTap});

  final String imageUrl;
  final String name;
  final List<String> types;
  final void Function() onTap;

  @override
  State<_PokemonItem> createState() => _PokemonItemState();
}

class _PokemonItemState extends State<_PokemonItem> {
  late final CachedNetworkImageProvider cachedImageProvider =
      CachedNetworkImageProvider(
    widget.imageUrl,
    maxWidth: 512,
  );
  Color _bgColor = Colors.green;

  void initPallete() async {
    final pallete = await CachedPallete()
        .generateFromImageProvier(widget.imageUrl, cachedImageProvider);
    if (mounted) {
      setState(() {
        _bgColor = Helper().darken(pallete.dominantColor!.color);
      });
    }
  }

  @override
  void initState() {
    super.initState();

    initPallete();
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: _bgColor,
      child: InkWell(
        onTap: widget.onTap,
        child: Stack(
          children: [
            Positioned(
              right: -25,
              bottom: -20,
              child: Opacity(
                opacity: .1,
                child: SvgPicture.asset(
                  'assets/pokemon_icon.svg',
                  width: 120,
                ),
              ),
            ),
            Positioned(
              right: 0,
              bottom: 0,
              child: Image(
                image: cachedImageProvider,
                width: 90,
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 24,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Text(
                      widget.name.capitalize!,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 24,
                      ),
                    ),
                  ),
                  ...widget.types.map(
                    (label) => PokemonType(label: label),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
