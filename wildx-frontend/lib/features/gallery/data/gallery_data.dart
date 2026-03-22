import 'package:flutter/material.dart';
import '../models/wildlife_animal.dart';

const List<String> galleryCategories = [
  'All',
  'Mammals',
  'Birds',
  'Reptiles',
  'Amphibians',
];

const List<String> galleryParks = [
  'All',
  'Yala National Park',
  'Minneriya National Park',
  'Wilpattu National Park',
  'Udawalawe National Park',
  'Sinharaja Forest',
  'Horton Plains',
  'Bundala National Park',
];

const List<WildlifeAnimal> wildlifeAnimals = [
  WildlifeAnimal(
    id: '1',
    name: 'Sri Lankan Leopard',
    scientificName: 'Panthera pardus kotiya',
    category: 'Mammals',
    parkLocation: 'Yala National Park',
    status: 'Endangered',
    emoji: '🐆',
  ),
  WildlifeAnimal(
    id: '2',
    name: 'Asian Elephant',
    scientificName: 'Elephas maximus',
    category: 'Mammals',
    parkLocation: 'Minneriya National Park',
    status: 'Endangered',
    emoji: '🐘',
  ),
  WildlifeAnimal(
    id: '3',
    name: 'Sri Lankan Sloth Bear',
    scientificName: 'Melursus ursinus inornatus',
    category: 'Mammals',
    parkLocation: 'Wilpattu National Park',
    status: 'Vulnerable',
    emoji: '🐻',
  ),
  WildlifeAnimal(
    id: '4',
    name: 'Peacock',
    scientificName: 'Pavo cristatus',
    category: 'Birds',
    parkLocation: 'Udawalawe National Park',
    status: 'Least Concern',
    emoji: '🦚',
  ),
  WildlifeAnimal(
    id: '5',
    name: 'Purple-faced Langur',
    scientificName: 'Trachypithecus vetulus',
    category: 'Mammals',
    parkLocation: 'Sinharaja Forest',
    status: 'Endangered',
    emoji: '🐒',
  ),
  WildlifeAnimal(
    id: '6',
    name: 'Mugger Crocodile',
    scientificName: 'Crocodylus palustris',
    category: 'Reptiles',
    parkLocation: 'Yala National Park',
    status: 'Vulnerable',
    emoji: '🐊',
  ),
  WildlifeAnimal(
    id: '7',
    name: 'Sri Lanka Junglefowl',
    scientificName: 'Gallus lafayettii',
    category: 'Birds',
    parkLocation: 'Horton Plains',
    status: 'Least Concern',
    emoji: '🐓',
  ),
  WildlifeAnimal(
    id: '8',
    name: 'Indian Cobra',
    scientificName: 'Naja naja',
    category: 'Reptiles',
    parkLocation: 'Bundala National Park',
    status: 'Least Concern',
    emoji: '🐍',
  ),
];

Color getStatusColor(String status) {
  switch (status) {
    case 'Endangered':
      return const Color(0xFFE53935);
    case 'Vulnerable':
      return const Color(0xFFFF9800);
    default:
      return const Color(0xFF2ECC71);
  }
}

Color getStatusBgColor(String status) {
  switch (status) {
    case 'Endangered':
      return const Color(0xFFFFEBEE);
    case 'Vulnerable':
      return const Color(0xFFFFF3E0);
    default:
      return const Color(0xFFE8F5E9);
  }
}
