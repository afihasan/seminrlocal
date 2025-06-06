

#' A theme function for a basic b/w theme
#'
#' @param plot.title.fontsize Title font size
#' @param sm.node.label.fontsize Font size for constructs
#' @param mm.node.label.fontsize Font size for measurement variables
#' @param sm.edge.label.fontsize Font size for path edges
#' @param mm.edge.label.fontsize  Font size for measurement model edges
#'
#' @return a theme object
#' @export
#'
# @examples
seminr_theme_old <- function(plot.title.fontsize = 24,
                                 mm.node.label.fontsize = 8,
                                 sm.node.label.fontsize = 12,
                                 mm.edge.label.fontsize = 7,
                                 sm.edge.label.fontsize = 9
){

  seminr_theme_create(plot.title.fontsize = plot.title.fontsize,
               mm.node.label.fontsize = mm.node.label.fontsize,
               sm.node.label.fontsize = sm.node.label.fontsize,
               mm.edge.label.fontsize = mm.edge.label.fontsize,
               sm.edge.label.fontsize = sm.edge.label.fontsize,
               construct.reflective.shape = "ellipse",
               construct.reflective.arrow = "backward",
               construct.reflective.use_weights = FALSE,
               construct.compositeA.shape = "ellipse",
               construct.compositeA.arrow = "backward",
               construct.compositeA.use_weights = FALSE,
               construct.compositeB.shape = "ellipse",
               construct.compositeB.arrow = "forward",
               construct.compositeB.use_weights = TRUE,
               manifest.reflective.shape = "box",
               manifest.compositeA.shape = "box",
               manifest.compositeB.shape = "box"
               )
}




# alternate Smart theme ----
#' A colored theme
#' @rdname seminr_theme_default
#' @export
seminr_theme_smart <- function(plot.title.fontsize = 24,
                                  mm.node.label.fontsize = 8,
                                  sm.node.label.fontsize = 12,
                                  mm.edge.label.fontsize = 7,
                                  sm.edge.label.fontsize = 9
){

  seminr_theme_create(plot.title.fontsize = plot.title.fontsize,
               mm.node.label.fontsize = mm.node.label.fontsize,
               sm.node.label.fontsize = sm.node.label.fontsize,
               mm.edge.label.fontsize = mm.edge.label.fontsize,
               sm.edge.label.fontsize = sm.edge.label.fontsize,
               sm.node.fill = "lightcyan",
               mm.node.fill = "lightgoldenrodyellow",
               construct.compositeA.arrow = "backward",
               construct.compositeB.arrow = "forward",
               construct.compositeA.use_weights = FALSE,
               construct.compositeB.use_weights = TRUE
  )
}


#' A theme function for a modern approach of visualizing PLS models in b/w
#'
#' @param plot.title.fontsize Title font size
#' @param sm.node.label.fontsize Font size for constructs
#' @param mm.node.label.fontsize Font size for measurement variables
#' @param sm.edge.label.fontsize Font size for path edges
#' @param mm.edge.label.fontsize  Font size for measurement model edges
#' @param construct.reflective.shape Shape of reflective constructs
#' @param construct.compositeA.shape Shape of composite constructs mode A
#' @param construct.compositeB.shape Shape of composite constructs mode B
#' @param construct.reflective.arrow Direction of arrows of reflective constructs
#' @param construct.compositeA.arrow Direction of arrows of composite constructs mode A
#' @param construct.compositeB.arrow Direction of arrows of composite constructs mode B
#' @param ... Other parameters for the seminr_theme_create function
#'
#' @return a theme object
#' @export
#'
# @examples
seminr_theme_default <- function(plot.title.fontsize = 24,
                                 mm.node.label.fontsize = 8,
                                 sm.node.label.fontsize = 12,
                                 mm.edge.label.fontsize = 7,
                                 sm.edge.label.fontsize = 9,
                                 construct.reflective.shape = "ellipse",
                                 construct.compositeA.shape = "hexagon",
                                 construct.compositeB.shape = "hexagon",
                                 construct.reflective.arrow = "backward",
                                 construct.compositeA.arrow = "backward",
                                 construct.compositeB.arrow = "forward", ...
){

  # TODO: remove arrows for composite
  # Check literature and add reference if available
  seminr_theme_create(plot.title.fontsize = plot.title.fontsize,
                      mm.node.label.fontsize = mm.node.label.fontsize,
                      sm.node.label.fontsize = sm.node.label.fontsize,
                      mm.edge.label.fontsize = mm.edge.label.fontsize,
                      sm.edge.label.fontsize = sm.edge.label.fontsize,
                      construct.reflective.shape = construct.reflective.shape,
                      construct.compositeA.shape = construct.compositeA.shape,
                      construct.compositeB.shape = construct.compositeB.shape,
                      construct.reflective.arrow = construct.reflective.arrow,
                      construct.compositeA.arrow = construct.compositeA.arrow,
                      construct.compositeB.arrow = construct.compositeB.arrow,
                      ...
  )
}



#' The theme function for an inverted theme on black background.
#'
#' @param plot.title.fontsize Title font size
#' @param sm.node.label.fontsize Font size for constructs
#' @param mm.node.label.fontsize Font size for measurement variables
#' @param sm.edge.label.fontsize Font size for path edges
#' @param mm.edge.label.fontsize  Font size for measurement model edges
#'
#' @return a theme object
#' @export
#'
# @examples
seminr_theme_dark <- function(plot.title.fontsize = 24,
                              mm.node.label.fontsize = 8,
                              sm.node.label.fontsize = 12,
                              mm.edge.label.fontsize = 7,
                              sm.edge.label.fontsize = 9) {
  seminr_theme_create(plot.title.fontsize = plot.title.fontsize,
                      mm.node.label.fontsize = mm.node.label.fontsize,
                      sm.node.label.fontsize = sm.node.label.fontsize,
                      mm.edge.label.fontsize = mm.edge.label.fontsize,
                      sm.edge.label.fontsize = sm.edge.label.fontsize,
                      plot.bgcolor = "black",
                      plot.title.fontcolor = "white",
                      sm.node.color = "white",
                      sm.node.fill = "darkslategray",
                      sm.node.label.fontcolor = "white",
                      sm.edge.label.fontcolor = "white",
                      sm.edge.negative.color = "firebrick",
                      sm.edge.positive.color = "white",
                      mm.node.color = "lightgray",
                      mm.node.fill = "darkgoldenrod4",
                      mm.node.label.fontcolor = "white",
                      mm.edge.label.fontcolor = "lightgray",
                      mm.edge.positive.color = "lightgray",
                      mm.edge.negative.color = "firebrick"
  )
}

