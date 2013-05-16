import processing.video.*;
	
	public float mySize = 5;
	public float change = (float) .05;
	public float mapSouthEdge = (float) 40.49;  
	public float mapNorthEdge = (float) 40.92;
	public float mapWestEdge = (float) -74.27;
	public float mapEastEdge= (float) -73.68;
	public PImage NYCMap;
	public PImage NYCGraffiti;
	public Graffiti[] GMLMovies;

	public void setup() {
		size(1000, 946);
	    String[] glocs=loadStrings("videolocation.csv");
	    GMLMovies= new Graffiti[glocs.length];
	    NYCGraffiti= loadImage("NYCGraffiti.png");
	    NYCMap = loadImage("NYC.png");
	    smooth();
	    noStroke();
	    for (int i=0; i<glocs.length; i++) {
	      String[] temp= split(glocs[i], ",");
	      LatLng latlng = new LatLng((float)Double.parseDouble(temp[1]), (float)Double.parseDouble(temp[2]));
	      GMLMovies[i] = new Graffiti(this, temp[0], latlng, temp[3]);
	      GMLMovies[i].loadMovie();
	      GMLMovies[i].GMLMov.noLoop();
	    }
	}

	public void draw() { 
	    tint(128, 128);
	    imageMode(CORNER);
	    image(NYCMap, 0, 0);
	    filter(GRAY);
	    noTint();
	    image(NYCGraffiti, 0,0);
	    for (int i=0; i<GMLMovies.length; i++) {
	      GMLMovies[i].drawMarker();
	      GMLMovies[i].mouseEvent();
	    }
	}
	
	public class LatLng //class which generates objects which store a latitude and longitude 
	  {
	    float Lat;
	    float Lng;
	    public LatLng(float lat, float lng)
	    {
	      Lat = lat;
	      Lng = lng;
	    }

	    float getLat() {
	      return Lat;
	    }

	    float getLng() {
	      return Lng;
	    }
	  }	
public class Graffiti{
    public PApplet p; //this class is drawing movies it needs to know what PApplet to draw into since it is not the class extending it
    public String moviename;
    public float launchY;
    public float launchX;
    public LatLng latlng;
    public Movie GMLMov;
    public String thelocation;
    public PFont locationfont = loadFont("Utsaah-Bold-48.vlw");

    Graffiti(PApplet _p, String moviename, LatLng latlng, String thelocation) {
      this.p=_p;
      this.moviename= moviename;
      this.launchY= map(latlng.getLat(), mapNorthEdge, mapSouthEdge, 0, height);
      this.launchX= map(latlng.getLng(), mapWestEdge, mapEastEdge, 0, width);
      this.thelocation= thelocation; 
   
    }

    public void movieEvent(Movie GMLMov) {
      GMLMov.read();
    }

    public void drawMarker() {
      fill(128, 0, 0);
      ellipse(launchX, launchY, mySize, mySize);
      if (mySize >10 || mySize < 1)
      {
        change*=-1;
      } 
      mySize+=change;
    }
    
    public void loadMovie(){
    GMLMov = new Movie(p,moviename); 
    GMLMov.loop();
  }
    
    public void drawMovie() {
      tint(255,64);
      imageMode(CENTER);
      image(GMLMov,launchX, launchY);
      fill(255,255,255,64);
      text(thelocation,launchX-160, launchY-125);
      
    }

    public void mouseEvent() {
    	
    	if (abs(mouseX-launchX)<5 && abs(mouseY-launchY)<5){
    		textFont(locationfont);
    		GMLMov.play();
    		drawMovie();
    	    }
    	    else{
    	    GMLMov.stop();	
    	 }
    }
  }


