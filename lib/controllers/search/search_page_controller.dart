import 'package:get/get.dart';
import 'package:pokedex/model/pokemon.dart';
import 'package:pokedex/services/repository/search/search_repo.dart';

class SearchPageController extends GetxController {
  final _searchRepo = SearchRepository();

  int _limit = 20;
  int _offset = 0;
  int _total = 0;
  bool _isLoaded = false;
  final _pokemons = <Pokemon>[].obs;

  RxList<Pokemon> get pokemons => _pokemons;

  Future<Map?> getEggGroup(int id) async {
    return await _searchRepo.getEggGroup(id);
  }

  Future<Map?> getGender(int id) async {
    return await _searchRepo.getGender(id);
  }

  Future<void> init() async {
    _limit = 20;
    _offset = 0;
    final res = await _searchRepo.fetchPokemen(_limit, _offset);

    _total = res.total;
    _pokemons.addAll(res.data);
    _pokemons.refresh();
  }

  Future<void> loadMore() async {
    _offset = _pokemons.length;
    final res = await _searchRepo.fetchPokemen(_limit, _offset);

    _isLoaded = false;
    _pokemons.addAll(res.data);
    _pokemons.refresh();
  }

  bool isCanLoadMore() {
    if (_isLoaded) {
      return false;
    }

    _isLoaded = true;
    return _pokemons.length < _total;
  }
}
