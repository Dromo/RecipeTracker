
Slider = class(Turbine.UI.Control);

function Slider:Constructor()
	Turbine.UI.Control.Constructor( self );

	self.drag = false;
	self.minThreshold = 0.0;
	self.maxThreshold = 1.0;
	self.value=self.minThreshold;
	
	self.line=Turbine.UI.Button();
	self.line:SetParent(self);
	self.line.MouseDown = function( sender, args )
		local dx = args.X - self.line:GetLeft()+5;
		local sw = self:GetWidth();
		self:SetValue(dx/sw);
	end

	self.MouseDown = function( sender, args )
		local dx = args.X - self.line:GetLeft()+5;
		local sw = self:GetWidth();
		self:SetValue(dx/sw);
	end
	
	self.button=Turbine.UI.Button();
	self.button:SetParent(self);
	self.button:SetZOrder(self.line:GetZOrder()+1);
	self.button.MouseDown = function( sender, args )
			self.drag = true;
			self.dragposition=self.value;
			self.mx0 = args.X;
			self.my0 = args.Y;
			--Turbine.Shell.WriteLine("started "..self.mx0.." "..self.my0.." "..(self.dragposition));
	end
	self.button.MouseUp = function( sender, args )
		self.drag = false;
	end
	self.button.MouseMove = function( sender, args )
		if self.drag then
			local dx = args.X - self.mx0;
			local dy = args.Y - self.my0;
			local x = self.button:GetLeft()+dx;
			local sw = self:GetWidth()-6;
			-- Turbine.Shell.WriteLine("dragged "..dx.." "..dy.." "..(x/sw));
			self:SetValue(x/sw);
		end
	end
	
	self:SetSize(100,10);
	
	self.line:SetBackColor(Turbine.UI.Color(.5,.5,.35));
	self.button:SetBackColor(Turbine.UI.Color(.7,.7,.5));
end

function Slider:SetValue(value)
	if value<self.minThreshold then
		value=self.minThreshold;
	end
	if value>self.maxThreshold then
		value=self.maxThreshold;
	end

	self.value=value;
	self.button:SetPosition((self:GetWidth()-5)*self.value, self:GetHeight()/2-3);
	self:ValueChanged();
end

function Slider:GetValue()
	return self.value;
end

function Slider:SetSize(width, height)
	Turbine.UI.Window.SetSize(self, width, height);
	self.line:SetSize( width, 2 );
	self.line:SetPosition(2, height/2-1);
	self.button:SetSize( 5, 8 );
	self.button:SetPosition((width-5)*self.value, height/2-3);
end

function Slider:SetHeight(height)
	self:SetSize(self:GetWidth(), height)
end

function Slider:SetWidth(width)
	self:SetSize(width, self:GetHeight())
end

-- 0.0 ... 1.0
function Slider:SetMin(minThreshold)
	if minThreshold>=0.0 and minThreshold<=1.0 then
		self.minThreshold = minThreshold;
		if self.value<self.minThreshold then
			self:SetValue(self.minThreshold);
		end
	end
end

-- 0.0 ... 1.0
function Slider:SetMax(maxThreshold)
	if maxThreshold>=0.0 and maxThreshold<=1.0 then
		self.maxThreshold = maxThreshold;
		if self.value>self.maxThreshold then
			self:SetValue(self.maxThreshold);
		end
	end
end

function Slider:ValueChanged()
end
