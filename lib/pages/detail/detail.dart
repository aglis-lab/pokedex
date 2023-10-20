import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';
import 'package:pokedex/components/badge.dart';
import 'package:pokedex/controllers/search/search_page_controller.dart';
import 'package:pokedex/helper/cached_pallete.dart';
import 'package:pokedex/helper/helper.dart';
import 'package:pokedex/model/pokemon.dart';

class DetailPage extends StatefulWidget {
  const DetailPage({super.key});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  Color _bgColor = Colors.green;
  final _searchController = Get.find<SearchPageController>();

  void init() async {
    final pokemon = Get.arguments as Pokemon;
    final imageUrl = pokemon.imageUrl;
    final pallete = await CachedPallete().generateFromImageProvier(
        imageUrl,
        CachedNetworkImageProvider(
          imageUrl,
          maxWidth: 512,
        ));

    setState(() {
      _bgColor = Helper().darken(pallete.dominantColor!.color);
    });
  }

  @override
  void initState() {
    super.initState();

    init();
  }

  @override
  Widget build(BuildContext context) {
    final pokemon = Get.arguments as Pokemon;
    final types = pokemon.types;
    final imageUrl = pokemon.imageUrl;
    final stats = pokemon.stats;

    return SafeArea(
      child: Scaffold(
        backgroundColor: _bgColor,
        body: Stack(
          children: [
            Positioned(
              left: 8,
              top: 8,
              child: BackButton(
                color: Colors.white,
                onPressed: () => Get.back(),
              ),
            ),
            Positioned(
              right: -30,
              top: 160,
              child: Opacity(
                opacity: .5,
                child: SvgPicture.asset(
                  'assets/pokemon_icon.svg',
                  colorFilter: ColorFilter.mode(
                    Colors.grey.shade200,
                    BlendMode.srcIn,
                  ),
                  width: 200,
                ),
              ),
            ),
            Positioned(
              left: 16,
              right: 16,
              top: 64,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        pokemon.name.capitalize!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 42,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      Row(
                        children: types
                            .map((e) => Padding(
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: PokemonType(label: e),
                                ))
                            .toList(),
                      )
                    ],
                  ),
                  Text(
                    Helper().idToNumber(pokemon.id),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              top: 350,
              bottom: 0,
              child: Container(
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.vertical(
                    top: Radius.circular(32),
                  ),
                ),
                child: DefaultTabController(
                  length: 4,
                  child: Scaffold(
                    primary: false,
                    appBar: AppBar(
                      primary: false,
                      automaticallyImplyLeading: false,
                      toolbarHeight: 26,
                      bottom: const TabBar(
                        tabs: [
                          Tab(text: 'About'),
                          Tab(text: 'Base Stats'),
                          Tab(text: 'Evolution'),
                          Tab(text: 'Moves'),
                        ],
                      ),
                    ),
                    body: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      child: TabBarView(
                        children: [
                          _About(
                            abilities: pokemon.abilities.join(', '),
                            height: pokemon.height,
                            weigth: pokemon.weight,
                            species: pokemon.species,
                            eggGroupName: pokemon.eggGroupName,
                            eggGroupSpecies: pokemon.eggGroupSpecies.isEmpty
                                ? '-'
                                : pokemon.eggGroupSpecies.join(', '),
                            gender: pokemon.genderName,
                          ),
                          _Stat(
                            name: pokemon.name,
                            attack: stats['attack']!,
                            defense: stats['defense']!,
                            hp: stats['hp']!,
                            specialAttack: stats['special-attack']!,
                            specialDefence: stats['special-defense']!,
                            speed: stats['speed']!,
                          ),
                          const Center(child: Text('No UI yet...')),
                          const Center(child: Text('No UI yet...')),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Positioned(
              top: 150,
              left: 75,
              right: 75,
              child: CachedNetworkImage(imageUrl: imageUrl),
            ),
          ],
        ),
      ),
    );
  }
}

class _Stat extends StatelessWidget {
  const _Stat(
      {super.key,
      required this.hp,
      required this.attack,
      required this.specialAttack,
      required this.specialDefence,
      required this.speed,
      required this.defense,
      required this.name});

  final String name;
  final int hp;
  final int attack;
  final int specialAttack;
  final int specialDefence;
  final int speed;
  final int defense;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
          },
          children: [
            createRow('HP', hp),
            createRow('Attack', attack),
            createRow('Defence', defense),
            createRow('Sp. Atk', specialAttack),
            createRow('Sp. Def', specialDefence),
            createRow('Speed', speed),
            createRow(
                'Total',
                hp +
                    attack +
                    defense +
                    specialAttack +
                    specialDefence +
                    specialAttack,
                120 * 6),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Type Defenses',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Text(
          'The effectiveness of each type on ${name.capitalize!}',
          style: const TextStyle(
            fontSize: 18,
            color: Colors.black54,
          ),
        ),
      ],
    );
  }

  TableRow createRow(String label, int value, [int maxValue = 120]) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Text(
                value.toString(),
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
              Flexible(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: LinearProgressIndicator(
                    color: value >= (maxValue / 2) ? Colors.green : Colors.red,
                    backgroundColor: Colors.grey,
                    value: min(maxValue, value) / maxValue,
                    minHeight: 6,
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _About extends StatelessWidget {
  const _About(
      {super.key,
      required this.species,
      required this.height,
      required this.weigth,
      required this.abilities,
      required this.gender,
      required this.eggGroupName,
      required this.eggGroupSpecies});

  final String species;
  final int height;
  final int weigth;
  final String abilities;

  final String gender;
  final String eggGroupName;
  final String eggGroupSpecies;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
          },
          children: [
            createRow('Species', species),
            createRow('Height',
                '${(height * .393701).toPrecision(2)}" ${height / 10} cm'),
            createRow('Weight',
                '${(weigth * 2.2).toPrecision(2)} lbs (${weigth / 10} kg)'),
            createRow('Abilities', abilities),
          ],
        ),
        const Padding(
          padding: EdgeInsets.only(top: 16, bottom: 8),
          child: Text(
            'Breeding',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
        Table(
          columnWidths: const {
            0: FixedColumnWidth(100),
          },
          children: [
            createRow(
                'Gender',
                gender == '-'
                    ? '-'
                    : gender == 'male'
                        ? '⚦ Male'
                        : '♀ Female'),
            createRow('Egg Group', eggGroupName),
            createRow('Egg Cycle', eggGroupSpecies),
          ],
        )
      ],
    );
  }

  TableRow createRow(String label, String value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 18,
              color: Colors.black54,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
