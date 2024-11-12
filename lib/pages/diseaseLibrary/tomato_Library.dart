import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:thesis/pages/plantInfo/corn_data.dart';
import 'package:thesis/pages/plantInfo/disease_Info.dart';

class TomatoLibrary extends StatefulWidget {
  const TomatoLibrary({Key? key}) : super(key: key);

  @override
  _TomatoLibraryState createState() => _TomatoLibraryState();
}

class _TomatoLibraryState extends State<TomatoLibrary> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  const Text(
                    "Tomato",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  const Text(
                    "Learn about tomato leaf diseases",
                    style: TextStyle(color: Colors.black54),
                  ),
                  const SizedBox(
                    height: 18,
                  ),
                  Expanded(
                    child: GridView.count(
                      primary: false,
                      padding: const EdgeInsets.only(right: 8, left: 8, top: 8),
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      crossAxisCount: 2,
                      children: [
                        buildImageWithOverlay(
                            "img/diseases_img/Tomato/tomato_healthy.jpg",
                            "Healthy Tomato Leaf",
                            infoWidget(
                                "img/diseases_img/Tomato/tomato_healthy.jpg",
                                "Healthy Tomato Leaf",
                                "Solanum lycopersicum",
                                "Healthy tomato leaves are compound, featuring 5-7 major leaflets with smaller leaflets in between. The leaves display a deep green color and have a distinctly aromatic smell when touched. The leaflets are slightly serrated along the edges and have a slightly fuzzy texture due to fine hairs covering both surfaces. A healthy tomato leaf shows good turgidity and stands firm on the stem. The leaves are arranged alternately on the main stem, and the surface appears slightly crinkled but uniform in texture. Each leaflet maintains consistent coloration throughout, without any yellowing or spots.",
                                "",
                                "")),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_bacterialspot.jpg",
                          "Bacterial Spot",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_bacterialspot.jpg",
                              "Bacterial Spot",
                              "Xanthomonas campestris pv. vesicatoria",
                              "Tomato bacterial spot appears as dark water-soaked lesions on leaves that may eventually lead to holes; it can also affect fruit quality significantly if not managed properly.",
                              "Management involves applying copper-based bactericides at symptom onset or during favorable weather conditions for bacterial spread; removing infected debris from planting areas helps control populations.",
                              "Preventive measures include using resistant tomato varieties while ensuring good sanitation practices within growing areas; regular monitoring allows for timely interventions against outbreaks."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_earlyblight.jpg",
                          "Early Blight",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_earlyblight.jpg",
                              "Early Blight",
                              "Alternaria solani",
                              "Early blight manifests as dark brown spots with concentric rings primarily on older tomato leaves; it can cause substantial yield loss if left unchecked.",
                              "Management includes applying fungicides during critical periods when environmental conditions favor early blight development; selecting resistant tomato cultivars can also mitigate risks effectively.",
                              "Preventative strategies involve crop rotation with non-susceptible crops while ensuring proper spacing between plants for improved airflow."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_lateblight.jpg",
                          "Late Blight",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_lateblight.jpg",
                              "Late Blight",
                              "Phytophthora infestans",
                              "Late blight appears as large dark green lesions that quickly turn brown on tomato leaves; it poses a significant risk of rapid plant death under favorable conditions.",
                              "Effective management includes immediate application of fungicides upon observing symptoms; however, utilizing resistant tomato varieties provides a sustainable long-term solution against late blight.",
                              "To prevent late blight outbreaks, practicing crop rotation with non-host crops along with maintaining good field hygiene is essential."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_leafmold.jpg",
                          "Leaf Mold",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_leafmold.jpg",
                              "Leaf Mold",
                              "Passalora fulva",
                              "Leaf mold is characterized by olive-green fuzzy growth primarily on the undersides of tomato leaves; it thrives in high humidity environments.",
                              "Management involves improving air circulation around plants through pruning while applying fungicides when necessary during periods of high humidity.",
                              "Preventive measures include selecting resistant tomato varieties along with ensuring proper spacing between plants for improved airflow."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_mosaicvirus.jpeg",
                          "Mosaic Virus",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_mosaicvirus.jpeg",
                              "Mosaic Virus",
                              "Tobamovirus",
                              "Tomato mosaic virus leads to mottled yellow-green patterns on leaves; it stunts plant growth significantly affecting yield potential.",
                              "Currently there is no cure for viral infections; management focuses on controlling aphid populations that spread the virus while removing infected plants promptly.",
                              "Preventive strategies involve using virus-resistant tomato cultivars along with practicing good hygiene measures in planting areas to minimize spread risk."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_septorialeafspot.jpg",
                          "Septoria Leaf Spot",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_septorialeafspot.jpg",
                              "Septoria Leaf Spot",
                              "Septoria lycopersici",
                              "Septoria leaf spot manifests as small circular spots surrounded by yellow halos primarily affecting older leaves; it can lead to premature defoliation if untreated.",
                              "Effective management includes applying fungicides at first sign of symptoms while ensuring proper sanitation practices are followed within planting areas.",
                              "Preventative measures involve rotating crops with non-susceptible species while utilizing resistant tomato varieties where available ."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_targetspot.jpg",
                          "Target Spot",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_targetspot.jpg",
                              "Target Spot",
                              "Corynespora cassiicola",
                              "Target spot appears as dark circular lesions with concentric rings on tomato leaves; it thrives under humid conditions leading to significant defoliation over time.",
                              "Management involves applying appropriate fungicides upon initial symptom detection while ensuring good cultural practices are maintained throughout the growing season.",
                              "To prevent target spot outbreaks, farmers should rotate crops regularly while employing resistant tomato cultivars whenever possible."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_twospottedspidermite.jpg",
                          "Two Spotter Spider Mite",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_twospottedspidermite.jpg",
                              "Two Spotter Spider Mite",
                              "Tetranychus urticae",
                              "Two-spotted spider mites cause stippling damage on tomato leaves due to feeding activity; they thrive under hot dry conditions leading to significant stress on plants over time.",
                              "Management includes applying miticides targeted specifically against spider mites while ensuring beneficial predatory insects are preserved within cropping systems.",
                              "Preventative strategies involve maintaining adequate moisture levels around plants along with regular monitoring for early signs of mite infestations allowing timely interventions when necessary."),
                        ),
                        buildImageWithOverlay(
                          "img/diseases_img/Tomato/tomato_yellowleafcurlvirus.jpeg",
                          "Yellow Leaf Curl Virus",
                          infoWidget(
                              "img/diseases_img/Tomato/tomato_yellowleafcurlvirus.jpeg",
                              "Yellow Leaf Curl Virus",
                              "Bemisia tabaci",
                              "Yellow leaf curl virus leads to upward curling of tomato leaves accompanied by yellowing; it severely stunts plant growth impacting overall yield potential significantly over time.",
                              "Currently there is no cure for viral infections; management focuses primarily on controlling whitefly populations which transmit this virus while promptly removing infected plants from fields.",
                              "Preventive measures include using virus-resistant tomato varieties along with implementing integrated pest management strategies targeting whiteflies effectively within cropping systems."),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              top: 16,
              left: 16,
              child: GestureDetector(
                onTap: () {
                  Navigator.pop(context);
                },
                child: Icon(
                  Icons.arrow_back,
                  color: Colors.black,
                  size: 30,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildImageWithOverlay(String imagePath, String text, Widget path) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => path),
        );
        log(text);
      },
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Stack(
          children: [
            Image.asset(
              imagePath,
              fit: BoxFit.cover,
              width: double.infinity,
              height: double.infinity,
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 100,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Colors.transparent, Colors.black],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                padding: EdgeInsets.all(12),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Text(
                    text,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
