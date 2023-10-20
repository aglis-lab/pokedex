import 'package:dio/dio.dart';
import 'package:pokedex/helper/helper.dart';
import 'package:pokedex/model/pagination.dart';
import 'package:pokedex/model/pokemon.dart';

class SearchRepository {
  final dio = Helper().dio;

  Future<Pagination<Pokemon>> fetchPokemen(int limit, [int offset = 0]) async {
    final res = await dio
        .get('https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$offset');
    final count = res.data['count'];
    final data = res.data['results'] ?? [];
    final results = <Pokemon>[];

    final futureItems = <Future<Response>>[];
    for (var item in data) {
      final pokemon = Pokemon.fromMap(item);
      results.add(pokemon);

      futureItems.add(dio.get(pokemon.url));
    }

    final items = await Future.wait(futureItems);
    for (var i = 0; i < items.length; i++) {
      results[i].detail = items[i].data;
    }

    return Pagination(total: count, data: results);
  }

  Future<Map?> getEggGroup(int id) async {
    try {
      final res = await dio.get(
        'https://pokeapi.co/api/v2/egg-group/$id',
      );
      return res.data;
    } catch (e) {
      return null;
    }
  }

  Future<Map?> getGender(int id) async {
    try {
      final res = await dio.get(
        'https://pokeapi.co/api/v2/gender/$id',
      );
      return res.data;
    } catch (e) {
      return null;
    }
  }
}
