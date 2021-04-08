import 'package:MentalHealthApp/models/events.dart';
import 'package:MentalHealthApp/providers/posts.dart';
import 'package:MentalHealthApp/screens/blog_detail.dart';
import 'package:MentalHealthApp/screens/profilescreen.dart';
import 'package:MentalHealthApp/widgets/event_detail.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

String defaultImage =
    "https://images.unsplash.com/photo-1534723328310-e82dad3ee43f?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=676&q=80";

List<Blog> events = [
  Blog(
      imgUrl: defaultImage,
      title: "Calm state of mind",
      isLatest: true,
      color: Colors.amber[300],
      description: "However good you are you need a good state of mind",
      date: "30/06/2001"),
  Blog(
      imgUrl: defaultImage,
      title: "Calm state of mind",
      isLatest: true,
      color: Colors.green[100],
      description: "However good you are you need a good state of mind",
      date: "30/06/2001"),
  Blog(
      imgUrl: defaultImage,
      title: "Calm state of mind",
      color: Colors.blue[200],
      isLatest: false,
      description: "However good you are you need a good state of mind",
      date: "30/06/2001"),
];

List<Blog> trendingEvents =
    events.where((element) => element.isLatest).toList();

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with TickerProviderStateMixin {
  var _isLoading = true;
  var _error = false;
  var _isInit = true;

  @override
  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      print("YESSSSSSSSSSSSS#######");
      Provider.of<Posts>(context).fetchAndSetPosts().then((value) {
        setState(() {
          _isLoading = false;
        });
      }).catchError((error) {
        print(error);
        setState(() {
          _error = true;
          _isLoading = false;
        });
      });
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    print(_isLoading);
    final test = Provider.of<Posts>(context, listen: false);
    final List<Post> posts = test.posts;

    final TabController _tabController = TabController(length: 2, vsync: this);
    return SafeArea(
      child: Scaffold(
        body: Stack(
          children: [
            Container(
              color: Colors.amber[100],
            ),
            _isLoading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Column(
                    children: [
                      //TITLE OF THE PAGE

                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.all(Radius.circular(30)),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(15.0),
                                child: Text(
                                  'Blogs',
                                  style: TextStyle(
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  Navigator.of(context).push(MaterialPageRoute(
                                      builder: (ctx) => ProfileScreen()));
                                },
                                child: CircleAvatar(
                                  radius: 30,
                                  backgroundImage: NetworkImage(
                                      'https://images.unsplash.com/photo-1554126807-6b10f6f6692a?ixid=MXwxMjA3fDB8MHxwaG90by1wYWdlfHx8fGVufDB8fHw%3D&ixlib=rb-1.2.1&auto=format&fit=crop&w=1350&q=80'),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      Container(
                        margin: EdgeInsets.only(top: 20),
                        child: SafeArea(
                          child: TabBar(
                            controller: _tabController,
                            unselectedLabelColor: Colors.grey,
                            labelColor: Colors.blue[800],
                            labelPadding: EdgeInsets.only(bottom: 4),
                            indicatorColor: Colors.blue[800],
                            indicatorPadding:
                                EdgeInsets.symmetric(horizontal: 10),
                            tabs: [
                              Text('All'),
                              Text('Trending'),
                              // Text('Upcoming'),
                              // Text('Completed'),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: TabBarView(
                          controller: _tabController,
                          children: [
                            //THE ALL TAB
                            Padding(
                              padding: const EdgeInsets.only(top: 25.0),
                              child: ListView.builder(
                                itemBuilder: (context, index) {
                                  return Column(
                                    children: [
                                      ListTile(
                                        onTap: () => Navigator.of(context).push(
                                          MaterialPageRoute(
                                              builder: (ctx) =>
                                                  BlogDetails(posts[index])
                                              // EventsDetailPage(
                                              //     news: widget.events[index]),
                                              ),
                                        ),
                                        leading: ClipRRect(
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(10),
                                          ),
                                          child: Image.network(
                                            events[index].imgUrl,
                                            height: 200,
                                            width: 70,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                        title: Text(
                                          posts[index].title,
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                        subtitle: Wrap(
                                          // mainAxisSize: MainAxisSize.min,
                                          // mainAxisAlignment: MainAxisAlignment.spaceAround,
                                          alignment: WrapAlignment.spaceBetween,
                                          direction: Axis.horizontal,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(0.0),
                                              child: Text(posts[index].desc),
                                            ),
                                            if (events[index].isLatest)
                                              Card(
                                                  //elevation: 2,
                                                  color: Colors.green[50],
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.all(
                                                              Radius.circular(
                                                                  30))),
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Text(
                                                      'Trending',
                                                      style: TextStyle(
                                                          color:
                                                              Colors.green[700],
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                  ))
                                          ],
                                        ),
                                      ),
                                      Divider()
                                    ],
                                  );
                                },
                                itemCount: posts.length,
                              ),
                            ),
                            //REGULAR TABS
                            tabs(trendingEvents, 'Trending'),
                          ],
                        ),
                      )
                    ],
                  ),
          ],
        ),
      ),
    );
  }
}

Widget tabs(List<Blog> events, String title) {
  return events.isEmpty
      ? Center(
          child: Text('No $title Events'),
        )
      : ListView.builder(
          itemBuilder: (context, index) {
            return Column(
              children: [
                ListTile(
                  onTap: () => Navigator.of(context).push(
                    MaterialPageRoute(
                        builder: (ctx) => EventDetail(
                              event: events[index],
                            )
                        // EventsDetailPage(
                        //     news: widget.events[index]),
                        ),
                  ),
                  leading: ClipRRect(
                    borderRadius: BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: Image.network(
                      events[index].imgUrl,
                      height: 200,
                      width: 70,
                      fit: BoxFit.cover,
                    ),
                  ),
                  title: Text(
                    events[index].title,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(events[index].date),
                      ),
                    ],
                  ),
                ),
                Divider()
              ],
            );
          },
          itemCount: events.length,
        );
}
