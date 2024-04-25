import 'package:flutter/material.dart';

class FeaturedPostPage extends StatelessWidget {
  const FeaturedPostPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Featured Today',
              style: TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            Text(
              'Viral video falsely claims elephants sent from Nepal to Qatar',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 20),
            Align(
              alignment: Alignment.centerLeft,
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Image
                  SizedBox(
                    width: MediaQuery.of(context).size.width * 0.25,
                    child: Center(
                      child: Image.network(
                        'https://scontent.fktm7-1.fna.fbcdn.net/v/t39.30808-6/438224087_792497989494984_8452363610187508156_n.jpg?_nc_cat=105&_nc_cb=99be929b-713f6db7&ccb=1-7&_nc_sid=5f2048&_nc_ohc=tjhi3YtuuBgQ7kNvgF-7oPl&_nc_ht=scontent.fktm7-1.fna&oh=00_AfDmgyklZ89MJQtX_ODHdm6af0SMPo1j_YAwITrD3BXiiA&oe=662FF5EF',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  SizedBox(width: 20),
                  // Title and body
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'A video of an elephant riding a truck is going viral on social media recently.In the video, the elephant is seen leaning on a tool and climbing onto the trolley of the truck.Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nullam auctor, ex nec suscipit malesuada, turpis libero tristique libero, sit amet tincidunt ante nisi quis ex.',
                          style: TextStyle(fontSize: 16),
                          maxLines: 4,
                          overflow: TextOverflow.ellipsis,
                        ),
                        SizedBox(height: 10),
                        Text(
                          'Read more...',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
