import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/national_park_model.dart';
import 'package:wildx_frontend/core/config/app_config.dart';

class NationalParkService {
  static final NationalParkService instance = NationalParkService._();
  NationalParkService._();
  factory NationalParkService() => instance;

  // GET /api/national-parks
  Future<List<NationalPark>> getAllParks() async {
    try {
      final res = await http.get(
        Uri.parse(AppConfig.parksBase),
      ).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List list = data['parks'] ?? [];
        if (list.isNotEmpty) return list.map((j) => NationalPark.fromJson(j)).toList();
      }
    } catch (_) {}
    return _localParks;
  }

  // Search by animal — GET /api/national-parks/search?animal=Elephant
  Future<List<NationalPark>> searchParkByAnimal(String animalName) async {
    try {
      final uri = Uri.parse('${AppConfig.parksBase}/search')
          .replace(queryParameters: {'animal': animalName});
      final res = await http.get(uri).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        final List list = data['parks'] ?? [];
        if (list.isNotEmpty) return list.map((j) => NationalPark.fromJson(j)).toList();
      }
    } catch (_) {}
    // Local fallback — filter by animal
    return _localParks
        .where((p) => p.animalTypes
            .any((a) => a.toLowerCase().contains(animalName.toLowerCase())))
        .toList();
  }

  // GET /api/national-parks/:id
  Future<NationalPark?> getParkById(int id) async {
    try {
      final res = await http.get(
        Uri.parse('${AppConfig.parksBase}/$id'),
      ).timeout(const Duration(seconds: 10));
      if (res.statusCode == 200) {
        final data = jsonDecode(res.body);
        return NationalPark.fromJson(data['park']);
      }
    } catch (_) {}
    return _localParks.where((p) => p.id == id).firstOrNull;
  }

  // ── Local fallback ─────────────────────────────────────────
  static final List<NationalPark> _localParks = [
    const NationalPark(
      id: 1, name: 'Yala National Park',
      description: 'Sri Lanka\'s most popular national park, famous for leopards.',
      location: 'Hambantota District, Southern Province',
      sizeInHectares: 97880,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 3500,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/4/45/A_Female_leopard_in_Yala_National_Park.jpg/1280px-A_Female_leopard_in_Yala_National_Park.jpg',
      contactNumber: '+94 47 222 0450', bestVisitingSeason: 'February to July',
      animalTypes: ['Asian Elephant','Sri Lankan Leopard','Spotted Deer','Crocodile','Water Buffalo','Sloth Bear'],
      rules: [ParkRule(id:1,parkId:1,rule:'Do not exit the vehicle inside the park'),
              ParkRule(id:2,parkId:1,rule:'Strictly no feeding of animals'),
              ParkRule(id:3,parkId:1,rule:'No littering — carry waste out')],
    ),
    const NationalPark(
      id: 2, name: 'Wilpattu National Park',
      description: 'Largest national park in Sri Lanka, famous for leopards.',
      location: 'North Western Province',
      sizeInHectares: 131693,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 3500,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/d/d9/Leopard_sitting_2.jpg/1280px-Leopard_sitting_2.jpg',
      contactNumber: '+94 25 222 3201', bestVisitingSeason: 'February to October',
      animalTypes: ['Sri Lankan Leopard','Asian Elephant','Sloth Bear','Spotted Deer'],
      rules: [ParkRule(id:4,parkId:2,rule:'Stay in the vehicle at all times'),
              ParkRule(id:5,parkId:2,rule:'No noise or loud music')],
    ),
    const NationalPark(
      id: 3, name: 'Minneriya National Park',
      description: 'Known for The Gathering — world\'s largest elephant congregation.',
      location: 'North Central Province',
      sizeInHectares: 8889,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 3000,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
      contactNumber: '+94 27 222 4052', bestVisitingSeason: 'June to October',
      animalTypes: ['Asian Elephant','Spotted Deer','Eagle','Crocodile'],
      rules: [ParkRule(id:6,parkId:3,rule:'Do not block elephant paths')],
    ),
    const NationalPark(
      id: 4, name: 'Udawalawe National Park',
      description: 'Elephant sanctuary near the Udawalawe reservoir.',
      location: 'Sabaragamuwa and Uva Provinces',
      sizeInHectares: 30821,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 3000,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/b/b5/Udawalawa_Elephant.jpg/1280px-Udawalawa_Elephant.jpg',
      contactNumber: '+94 47 223 0732', bestVisitingSeason: 'May to September',
      animalTypes: ['Asian Elephant','Water Buffalo','Crocodile','Eagle','Spotted Deer'],
      rules: [ParkRule(id:7,parkId:4,rule:'Keep vehicle engines off near animals')],
    ),
    const NationalPark(
      id: 5, name: 'Horton Plains National Park',
      description: 'Highland plateau with World\'s End cliff.',
      location: 'Central Province',
      sizeInHectares: 3160,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 3500,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/0/0e/Horton_Plains_National_Park_World%27s_End.jpg/1280px-Horton_Plains_National_Park_World%27s_End.jpg',
      contactNumber: '+94 52 222 8740', bestVisitingSeason: 'January to April',
      animalTypes: ['Sambar Deer','Purple-faced Langur','Sloth Bear'],
      rules: [ParkRule(id:8,parkId:5,rule:'Stay on designated trails')],
    ),
    const NationalPark(
      id: 6, name: 'Bundala National Park',
      description: 'Ramsar wetland site famous for flamingos.',
      location: 'Southern Province',
      sizeInHectares: 6216,
      openingTime: '06:00:00', closingTime: '18:00:00', entryFee: 2500,
      imageUrl: 'https://upload.wikimedia.org/wikipedia/commons/thumb/1/1e/Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg/1280px-Sri_Lankan_elephant_%28Elephas_maximus_maximus%29.jpg',
      contactNumber: '+94 47 223 8471', bestVisitingSeason: 'November to March',
      animalTypes: ['Asian Elephant','Crocodile','Flamingo','Pelican'],
      rules: [ParkRule(id:9,parkId:6,rule:'No disturbance to nesting birds')],
    ),
  ];
}
