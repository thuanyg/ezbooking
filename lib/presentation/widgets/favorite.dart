import 'package:ezbooking/core/utils/dialogs.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_bloc.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_event.dart';
import 'package:ezbooking/presentation/pages/event/bloc/favorite_state.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Widget buildFavoriteButton({
  required String eventID,
  required FavoriteBloc bloc,
}) {
  User? user = FirebaseAuth.instance.currentUser;
  bloc.add(CheckFavoriteEvent(user!.uid, eventID));
  return BlocBuilder(
    bloc: bloc,
    builder: (context, state) {
      bool isSaved = false;
      if (state is FavoriteEventSaved) {
        isSaved = true;
      }
      if (state is FavoriteEventUnSaved) {
        isSaved = false;
      }
      return Container(
        height: 36,
        width: 36,
        decoration: BoxDecoration(
          color: const Color(0xfffff6f2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: IconButton(
          icon: Icon(
            Icons.bookmark,
            size: 18,
            color: isSaved ? Colors.red : Colors.grey.shade400,
          ),
          onPressed: () {
            if(!isSaved){
              bloc.add(SaveFavoriteEvent(user.uid, eventID));
            } else {
              bloc.add(UnSaveFavoriteEvent(user.uid, eventID));
            }
          },
        ),
      );
    },
  );
}
