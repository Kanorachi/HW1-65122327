import 'dart:io';

class Room {
  String roomNumber;
  String roomType;
  double price;
  bool isBooked;
  String? bookedById;

  Room(this.roomNumber, this.roomType, this.price, {this.isBooked = false, this.bookedById});

  void bookRoom(String guestId) {
    if (!isBooked) {
      isBooked = true;
      bookedById = guestId;
      print('Room $roomNumber booked successfully by Guest ID $guestId.');
    } else {
      print('Room $roomNumber is already booked.');
    }
  }

  void cancelBooking() {
    if (isBooked) {
      isBooked = false;
      bookedById = null;
      print('Room $roomNumber booking cancelled.');
    } else {
      print('Room $roomNumber is not booked.');
    }
  }

  @override
  String toString() {
    return 'Room Number: $roomNumber, Type: $roomType, Price: $price, Booked: $isBooked, Booked By: ${bookedById ?? 'None'}';
  }
}

class Guest {
  String name;
  String guestId;
  List<Room> bookedRooms = [];

  Guest(this.name, this.guestId);

  void bookRoom(Room room) {
    if (!room.isBooked) {
      room.bookRoom(guestId);
      bookedRooms.add(room);
      print('Guest $name booked room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is already booked.');
    }
  }

  void cancelRoom(Room room) {
    if (room.isBooked) {
      room.cancelBooking();
      bookedRooms.remove(room);
      print('Guest $name cancelled room ${room.roomNumber}.');
    } else {
      print('Room ${room.roomNumber} is not booked.');
    }
  }

  @override
  String toString() {
    return 'Guest Name: $name, ID: $guestId, Booked Rooms: ${bookedRooms.map((r) => r.roomNumber).join(', ')}';
  }
}

class Hotel {
  List<Room> rooms = [];
  List<Guest> guests = [];

  void addRoom(Room room) {
    rooms.add(room);
    print('Room ${room.roomNumber} added to hotel.');
  }

  void removeRoom(Room room) {
    rooms.remove(room);
    print('Room ${room.roomNumber} removed from hotel.');
  }

  void registerGuest(Guest guest) {
    guests.add(guest);
    print('Guest ${guest.name} registered.');
  }

  void bookRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);
    if (guest != null && room != null) {
      guest.bookRoom(room);
    } else {
      print('Guest or Room not found.');
    }
  }

  void cancelRoom(String guestId, String roomNumber) {
    Guest? guest = getGuest(guestId);
    Room? room = getRoom(roomNumber);
    if (guest != null && room != null) {
      guest.cancelRoom(room);
    } else {
      print('Guest or Room not found.');
    }
  }

  Room? getRoom(String roomNumber) {
    for (var room in rooms) {
      if (room.roomNumber == roomNumber) {
        return room;
      }
    }
    return null;
  }

  Guest? getGuest(String guestId) {
    for (var guest in guests) {
      if (guest.guestId == guestId) {
        return guest;
      }
    }
    return null;
  }

  void searchRoom(String roomNumber) {
    Room? room = getRoom(roomNumber);
    if (room != null) {
      print('| Room Number | Room Type | Price | Booked | Booked By |');
      print('|-------------|-----------|-------|--------|-----------|');
      print('| ${room.roomNumber.padRight(12)} | ${room.roomType.padRight(10)} | ${room.price.toString().padRight(5)} | ${room.isBooked ? 'true' : 'false'}    | ${room.bookedById ?? 'None'}  |');
    } else {
      print('Room not found.');
    }
  }

  void searchGuest(String guestId) {
    Guest? guest = getGuest(guestId);
    if (guest != null) {
      print('| Guest ID | Guest Name | Booked Rooms |');
      print('|----------|------------|--------------|');
      print('| ${guest.guestId.padRight(8)} | ${guest.name.padRight(10)} | ${guest.bookedRooms.map((r) => r.roomNumber).join(', ').padRight(12)} |');
    } else {
      print('Guest not found.');
    }
  }

  void listRooms() {
    if (rooms.isEmpty) {
      print('No rooms available.');
    } else {
      print('Rooms:');
      print('| Room Number | Room Type | Price | Booked | Booked By |');
      print('|-------------|-----------|-------|--------|-----------|');
      for (var room in rooms) {
        print('| ${room.roomNumber.padRight(12)} | ${room.roomType.padRight(10)} | ${room.price.toString().padRight(5)} | ${room.isBooked ? 'true' : 'false'}    | ${room.bookedById ?? 'None'}  |');
      }
    }
  }

  void listGuests() {
    if (guests.isEmpty) {
      print('No guests registered.');
    } else {
      print('Guests:');
      print('| Guest ID | Guest Name | Booked Rooms |');
      print('|----------|------------|--------------|');
      for (var guest in guests) {
        print('| ${guest.guestId.padRight(8)} | ${guest.name.padRight(10)} | ${guest.bookedRooms.map((r) => r.roomNumber).join(', ').padRight(12)} |');
      }
    }
  }
}

void main() {
  Hotel hotel = Hotel();

  while (true) {
    print('--- Hotel Management System ---');
    print('1. Add Room');
    print('2. Remove Room');
    print('3. Register Guest');
    print('4. Book Room');
    print('5. Cancel Room');
    print('6. List Rooms');
    print('7. List Guests');
    print('8. Search Room');
    print('9. Search Guest');
    print('10. Exit');
    stdout.write('Select an option: ');
    String? choice = stdin.readLineSync();

    switch (choice) {
      case '1':
        stdout.write('Enter room number: ');
        String roomNumber = stdin.readLineSync()!;
        stdout.write('Enter room type (Single, Double, Suite): ');
        String roomType = stdin.readLineSync()!;
        stdout.write('Enter room price: ');
        double price = double.parse(stdin.readLineSync()!);
        hotel.addRoom(Room(roomNumber, roomType, price));
        break;

      case '2':
        stdout.write('Enter room number to remove: ');
        String roomNumber = stdin.readLineSync()!;
        Room? room = hotel.getRoom(roomNumber);
        if (room != null) {
          hotel.removeRoom(room);
        } else {
          print('Room not found.');
        }
        break;

      case '3':
        stdout.write('Enter guest name: ');
        String name = stdin.readLineSync()!;
        stdout.write('Enter guest ID: ');
        String guestId = stdin.readLineSync()!;
        hotel.registerGuest(Guest(name, guestId));
        break;

      case '4':
        stdout.write('Enter guest ID: ');
        String guestId = stdin.readLineSync()!;
        stdout.write('Enter room number to book: ');
        String roomNumber = stdin.readLineSync()!;
        hotel.bookRoom(guestId, roomNumber);
        break;

      case '5':
        stdout.write('Enter guest ID: ');
        String guestId = stdin.readLineSync()!;
        stdout.write('Enter room number to cancel: ');
        String roomNumber = stdin.readLineSync()!;
        hotel.cancelRoom(guestId, roomNumber);
        break;

      case '6':
        hotel.listRooms();
        break;

      case '7':
        hotel.listGuests();
        break;

      case '8':
        stdout.write('Enter room number to search: ');
        String roomNumber = stdin.readLineSync()!;
        hotel.searchRoom(roomNumber);
        break;

      case '9':
        stdout.write('Enter guest ID to search: ');
        String guestId = stdin.readLineSync()!;
        hotel.searchGuest(guestId);
        break;

      case '10':
        print('Exiting...');
        return;

      default:
        print('Invalid choice. Please try again.');
    }
    print('');
  }
}
