function s = px2mm(s, location)
	s.xmm = (s.xpos - location.xcenter) ./ location.pxpermm;
	s.ymm = -(s.ypos - location.ycenter) ./ location.pxpermm;
end
